<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/9/2017 5:25 AM
     Edited on:     2/16/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Export-GraphOauthAccessToken.ps1
	===========================================================================
	.DESCRIPTION
		Export-GraphOauthAccessTokenFunction
#>

<#
    .SYNOPSIS
        Exports a Graph OAuth Access Token object to a file.
    
    .DESCRIPTION
        Used to Export a Graph OAuth Access Token object to a file so it can later be imported.
    
    .PARAMETER Path
        Specifies the path to the file where the XML representation of the Graph AccessToken object will be stored
    
    .PARAMETER LiterlPath
        Specifies the path to the file where the XML representation of the Graph AccessToken object will be stored. Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.
    
    .PARAMETER Encoding
        Specifies the type of encoding for the target file. The acceptable values for this parameter are:
        
        -- ASCII
        -- UTF8
        -- UTF7
        -- UTF32
        -- Unicode
        -- BigEndianUnicode
        -- Default
        -- OEM
        
        The default value is Unicode.
    
    .PARAMETER AccessToken
        Graph OAuth Acess Token Object to be exported.
    
    .EXAMPLE
        PS C:\> $GraphAccessToken | Export-GraphOAuthAccessToken -Path 'c:\GraphAccessToken.xml'
    
    .OUTPUTS
        System.IO.FileInfo, System.IO.FileInfo
    
    .NOTES
        This is an Export-Clixml wrapper.
        See Import-GraphOauthAccessToken for importing exported Graph AccessToken Objects
        See Get-GraphOauthAccessToken for obtaining a Graph AccessToken Objects
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken
    .LINK 
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
#>
function Export-GraphOauthAccessToken {
    [CmdletBinding(DefaultParameterSetName = 'Path',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOAuthAccessToken',
                   ConfirmImpact = 'Low',
                   SupportsShouldProcess = $true)]
    [OutputType([System.IO.FileInfo])]
    param
    (
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LiterlPath,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('ASCII', 'UTF8', 'UTF7', 'UTF32', 'Unicode', 'BigEndianUnicode', 'Default', 'OEM')]
        [string]$Encoding = 'Unicode',
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [pstypename('MSGraphAPI.OAuth.AccessToken')]
        [Alias('Token')]
        [System.Management.Automation.PSObject]$AccessToken
    )
    
    Process {
        # Strip the ScriptProperty properties to prevent cleartext secrets in the export
        # These will be reconstituted when imported
        $ExportProperties = $AccessToken.psobject.Properties.where({ $_.MemberType -ne 'ScriptProperty' }).Name
        Write-Verbose "Propertes: $($ExportProperties -join ' ')"
        $ExportToken = $AccessToken | Select-Object -Property $ExportProperties
        switch ($PsCmdlet.ParameterSetName) {            
            'Path' {
                $Params = @{
                    Encoding = $Encoding
                    Path = $Path
                    InputObject = $ExportToken
                }
                $Target = $Path
            }
            'LiteralPath' {
                $Params = @{
                    Encoding = $Encoding
                    LiteralPath = $LiterlPath
                    InputObject = $ExportToken
                }
                $Target = $LiteralPath
            }
        }
        if ($pscmdlet.ShouldProcess($Target)) {
            Export-Clixml @Params
        }
    }
}
