<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/9/2017 6:55 AM
     Edited on:     3/30/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Import-GraphOauthAccessToken.ps1
	===========================================================================
	.DESCRIPTION
		Import-GraphOauthAccessToken function
#>

<#
    .SYNOPSIS
        Imports an exported Graph OAuth Access Token Object
    
    .DESCRIPTION
        Imports an exported Graph OAuth Access Token Object and retruns a Graph  OAuth Access Token Object.
    
    .PARAMETER Path
        Specifies the XML files where the Graph Application Object was exported.
    
    .PARAMETER LiteralPath
        Specifies the XML files where the Graph Application Object was exported. Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.
    
    .EXAMPLE
        PS C:\> $GraphAccessToken = Import-GraphOAuthAccessToken -Path 'c:\GraphAccessToken.xml'
    
    .NOTES
        See Export-GraphOauthAccessToken for exporting Graph AcessToken Objects
        See Get-GraphOauthAccessToken for obtaining a Graph Access Token from the API
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    
    .OUTPUTS
        MSGraphAPI.Oauth.AccessToken
#>
function Import-GraphOauthAccessToken {
    [CmdletBinding(DefaultParameterSetName = 'Path',
                   ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOAuthAccessToken',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.Oauth.AccessToken')]
    param
    (
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath
    )
    
    Process {
        Switch ($PsCmdlet.ParameterSetName) {
            'Path' {
                $ImportFiles = $Path
            }
            'LiteralPath' {
                $ImportFiles = $LiteralPath
            }
        }
        foreach ($ImportFile in $ImportFiles) {
            if ($pscmdlet.ShouldProcess($ImportFile)) {
                Write-Verbose "Processing $($ImportFile)."
                $Params = @{
                    "$($PsCmdlet.ParameterSetName)" = $ImportFile
                    ErrorAction = 'Stop'
                }
                try {
                    $InObject = Import-Clixml @Params
                }
                Catch {
                    $ErrorMessage = "Unable to import from '{0}': {1}" -f @(
                        $ImportFile
                        $_.Exception.Message
                    )
                    Write-Error $ErrorMessage
                }
                Write-Verbose "Reconstituting Application object"
                $Application = $InObject.Application | New-GraphApplication
                Write-Verbose 'Reconstituting Session object'
                $Session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
                $Session.Certificates = $InObject.Session.Certificates
                $Session.Credentials = $InObject.Session.Credentials
                try {
                    $InObject.Session.Headers.GetEnumerator() | ForEach-Object {
                        $Session.Headers[$_.key] = $_.value
                    }
                }
                catch {
                    Write-Warning "Session headers could not be imported."
                }
                $Session.MaximumRedirection = $InObject.Session.MaximumRedirection
                $Session.Proxy = $InObject.Session.Proxy
                $Session.UseDefaultCredentials = $InObject.Session.UseDefaultCredentials
                $Session.UserAgent = $Application.UserAgent
                
                Write-Verbose 'Create Graph Token Object'
                $Params = @{
                    Application = $Application
                    AccessTokenCredential = $InObject.AccessTokenCredential
                    RefreshTokenCredential = $InObject.RefreshTokenCredential
                    RequestedDate = $InObject.RequestedDate
                    Response = $InObject.Response
                    ResponseHeaders = $InObject.ResponseHeaders
                    LastRequestDate = $InObject.LastRequestDate
                    Session = $Session
                    GUID = $InObject.GUID
                }
                New-GraphOauthAccessToken @Params
            } #End Should Process
        } #End Foreach
    } #End Process
} #End Function
