<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 8:26 AM
     Edited on:     2/14/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Export-GraphApplication.ps1
	===========================================================================
	.DESCRIPTION
		Export-GraphApplication Function
#>

<#
    .SYNOPSIS
        Exports a Graph Application object to a file.
    
    .DESCRIPTION
        Used to Export a Graph Application object to a file so it can later be imported.
    
    .PARAMETER Path
        Specifies the path to the file where the XML representation of the Graph Application object will be stored
    
    .PARAMETER LiterlPath
        Specifies the path to the file where the XML representation of the Graph Application object will be stored. Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.
    
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
    
    .PARAMETER Application
        Graph Application Object to be exported.
    
    .EXAMPLE
        PS C:\> $GraphApp | Export-RedditApplication -Path 'c:\GraphApp.xml'
    
    .OUTPUTS
        System.IO.FileInfo, System.IO.FileInfo
    
    .NOTES
        This is an Export-Clixml wrapper.
        See Import-GraphApplication for importing exported Graph Application Objects
        See New-GraphApplication for creating new Graph Application objects
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication
    .Link
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication
    .Link
        http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication
#>
function Export-GraphApplication {
    [CmdletBinding(DefaultParameterSetName = 'Path',
                   ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication',
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
        [pstypename('MSGraphAPI.Application')]
        [Alias('App', 'GraphApplication')]
        [System.Management.Automation.PSObject]$Application
    )
    
    Process {
        $ExportProperties = $Application.psobject.Properties.where({ $_.MemberType -ne 'ScriptProperty' }).Name
        Write-Verbose "Propertes: $($ExportProperties -join ' ')"
        $ExportApplication = $Application | Select-Object -Property $ExportProperties
        switch ($PsCmdlet.ParameterSetName) {
            'Path' {
                $Params = @{
                    Encoding = $Encoding
                    Path = $Path
                    InputObject = $ExportApplication
                }
                $Target = $Path
            }
            'LiteralPath' {
                $Params = @{
                    Encoding = $Encoding
                    LiteralPath = $LiterlPath
                    InputObject = $ExportApplication
                }
                $Target = $LiteralPath
            }
        }
        if ($pscmdlet.ShouldProcess("Target")) {
            Export-Clixml @Params
        }
    }
}