<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 8:48 AM
     Edited on:     2/27/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-GraphOauthAuthorizationCode.ps1
	===========================================================================
	.DESCRIPTION
		Get-GraphOauthAuthorizationCode Function
#>

<#
    .SYNOPSIS
        Retrieves an OAuth Authorization code form Microsoft
    
    .DESCRIPTION
        Retrieves an OAuth Authorization code form Microsoft for a given Graph Application. This commandlet requires an interactive session as you will need to provide your credentials and authorize the Graph Application. The OAuth Authorization code will be used to obtain an OAuth Access Token. 
    
    .PARAMETER Application
        MSGraphAPI.Application object (See New-GraphApplication)
    
    .PARAMETER BaseURL
        The base URL for obtaining an OAuth Authorization Code form Microsoft. This is provided in the event that a different URL is required. The default is 
        
            https://login.microsoftonline.com/common/oauth2/authorize 
    
    .EXAMPLE
        		PS C:\> $GraphAuthCode = Get-GraphOauthAuthorizationCode -Application $GraphApp
    
    .OUTPUTS
        MSGraphAPI.Oauth.AuthorizationCode

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode
    .LINK
        https://graph.microsoft.io/en-us/docs/authorization/auth_overview
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication
#>
function Get-GraphOauthAuthorizationCode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.Oauth.AuthorizationCode')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('App')]
        [PSTypeName('MSGraphAPI.Application')]$Application,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Alias('URL')]
        [string]$BaseURL = 'https://login.microsoftonline.com/common/oauth2/authorize'
    )
    Process {
        if (-not $pscmdlet.ShouldProcess($Application.ClientID)) {
            return
        }
        $Client_Id = [System.Web.HttpUtility]::UrlEncode($Application.ClientId)
        $Redirect_Uri = [System.Web.HttpUtility]::UrlEncode($Application.RedirectUri)
        $Url = "{0}?response_type=code&redirect_uri={1}&client_id={2}" -f @(
            $BaseURL
            $Redirect_Uri
            $Client_Id
        )
        Write-Verbose "URL: '$URL'"
        $Params = @{
            TypeName = 'System.Windows.Forms.Form'
            Property = @{
                Width = 440
                Height = 640
            }
        }
        $Form = New-Object @Params
        $Params = @{
            TypeName = 'System.Windows.Forms.WebBrowser'
            Property = @{
                Width = 420
                Height = 600
                Url = $Url
            }
        }
        $Web = New-Object @Params
        $DocumentCompleted_Script = {
            if ($web.Url.AbsoluteUri -match "error=[^&]*|code=[^&]*") {
                $form.Close()
            }
        }
        # ScriptErrorsSuppressed must be $false or AD FS tenants will fail on Windows Integrated Authentication pages
        $web.ScriptErrorsSuppressed = $false
        $web.Add_DocumentCompleted($DocumentCompleted_Script)
        $form.Controls.Add($web)
        $form.Add_Shown({ $form.Activate() })
        [void]$form.ShowDialog()
        
        $QueryOutput = [System.Web.HttpUtility]::ParseQueryString($web.Url.Query)
        $Response = @{ }
        foreach ($key in $queryOutput.Keys) {
            $Response["$key"] = $QueryOutput[$key]
        }
        $SecAuthCode = 'NOAUTHCODE' | ConvertTo-SecureString -AsPlainText -Force
        $AuthCodeCredential = [pscredential]::new('NOAUTHCODE', $SecAuthCode)
        if ($Response.Code) {
            $SecAuthCode = $Response.Code | ConvertTo-SecureString -AsPlainText -Force
            $AuthCodeCredential = [pscredential]::new('AuthCode', $SecAuthCode)
            $Response.Remove('Code')
        }
        [pscustomobject]@{
            PSTypeName = 'MSGraphAPI.Oauth.AuthorizationCode'
            AuthCodeCredential = $AuthCodeCredential
            ResultURL = $web.Url.psobject.copy()
            Application = $Application
            AuthCodeBaseURL = $BaseURL
            Response = $Response
            Issued = Get-date
        }
        [void]$form.Close()
        [void]$Web.Dispose()
        [void]$Form.Dispose()
    }
}
