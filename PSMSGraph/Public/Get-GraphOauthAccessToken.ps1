<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 10:26 AM
     Edited on::    4/15/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-GraphOauthAccessToken.ps1
	===========================================================================
	.DESCRIPTION
		Get-GraphOauthAccessToken Function
#>

<#
    .SYNOPSIS
        Retieves an OAuth Access Token from Microsoft
    
    .DESCRIPTION
        A detailed description of the Get-GraphOauthAccessToken function.
    
    .PARAMETER AuthenticationCode
        The Authentication Code returned from Get-GraphOauthAuthorizationCode
    
    .PARAMETER BaseURL
        The Base URL used for retrieving OAuth Acces Tokens. This is not required. the default is
        
        https://login.microsoftonline.com/common/oauth2/token
    
    .PARAMETER Resource
        The resource for which the OAuth Access token will be requested. The default is
        
            https://graph.microsoft.com
    
        You must set the resource to match the endpoints your token will be valid for.

            Microsft Graph:              https://graph.microsoft.com
            Azure AD Graph API:          https://graph.windows.net
            Office 365 Unified Mail API: https://outlook.office.com
        
        If you need to access more than one resrouce, you will need to request multiple OAuth Access Tokens and use the correct tokens for the correct endpoints.

    .EXAMPLE
        PS C:\> $ClientCredential = Get-Credential
        PS C:\> $Params = @{
        Name = 'MyGraphApp'
        Description = 'My Graph Application!'
        ClientCredential = $ClientCredential
        RedirectUri = 'https://adataum/ouath?'
        UserAgent = 'Windows:PowerShell:GraphApplication'
        }
        PS C:\> $GraphApp = New-GraphApplication @Params
        PS C:\> $GraphAuthCode = Get-GraphOauthAuthorizationCode -Application $GraphApp 
        PS C:\> $GraphAccessToken = Get-GraphOauthAccessToken -AuthenticationCode $GraphAuthCode
    
    .OUTPUTS
        MSGraphAPI.Oauth.AccessToken
    
    .NOTES
        See Export-GraphOauthAccessToken for exporting Graph Acess Token Objects
        See Import-GraphOauthAccessToken for importing exported Graph AcessToken Objects
        See Update-GraphOauthAccessToken for refreshing the Graph Access Token
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken
    .LINK
        https://graph.microsoft.io/en-us/docs/authorization/auth_overview
#>
function Get-GraphOauthAccessToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText","")]
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.Oauth.AccessToken')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [pstypename('MSGraphAPI.Oauth.AuthorizationCode')]
        [ValidateNotNullOrEmpty()]
        [Alias('AuthCode')]
        $AuthenticationCode,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Alias('URL')]
        [string]$BaseURL = 'https://login.microsoftonline.com/common/oauth2/token',
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$Resource = 'https://graph.microsoft.com'
    )
    
    Process {
        $Application = $AuthenticationCode.Application
        if (-not $pscmdlet.ShouldProcess($Application.ClientID)) {
            return
        }
        $Client_Id = [System.Web.HttpUtility]::UrlEncode($Application.ClientID)
        $Redirect_uri = [System.Web.HttpUtility]::UrlEncode($Application.RedirectUri)
        $Resource_encoded = [System.Web.HttpUtility]::UrlEncode($Resource)
        $AuthCode = [System.Web.HttpUtility]::UrlEncode($AuthenticationCode.GetAuthCode())
        $Body = @(
            'grant_type=authorization_code'
            '&redirect_uri={0}' -f $Redirect_uri
            '&client_id={0}' -f $Client_Id
            '&code={0}' -f $AuthCode
            '&resource={0}' -f $Resource_encoded
            '&client_secret={0}' -f [System.Web.HttpUtility]::UrlEncode(
                $Application.GetClientSecret())
        ) -join ''
        Write-Verbose "Body: $Body"
        $RequestedDate = Get-Date
        $Params = @{
            Uri = $BaseURL
            Method = 'POST'
            ContentType = "application/x-www-form-urlencoded"
            Body = $Body
            ErrorAction = 'Stop'
            SessionVariable = 'Session'
        }
        try {
            Write-Verbose "Retrieving OAuth Access Token from $BaseURL..."
            $Result = Invoke-WebRequest @Params
        }
        catch {
            $response = $_.Exception.Response
            $Stream = $response.GetResponseStream()
            $Stream.Position = 0
            $StreamReader = New-Object System.IO.StreamReader $Stream
            $ResponseBody = $StreamReader.ReadToEnd()
            $ErrorMessage = "Requesting OAuth Access Token from '{0}' Failed: {1}: {2}" -f $BaseURL, 
                $_.Exception.Message, $ResponseBody
            Write-Error -message $ErrorMessage -Exception $_.Exception
            return
        }
        try {
            $Content = $Result.Content | ConvertFrom-Json -ErrorAction Stop
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            $Params = @{
                MemberType = 'NoteProperty'
                Name = 'Respone' 
                Value = $Result
            }
            $_.Exception | Add-Member @Params
            $Message = "Failed to convert response from JSON: {0}" -f $ErrorMessage
            Write-Error -Exception $_.Exception -Message $Message
            return
        }
        $AccessTokenCredential = [pscredential]::new('access_token', $($Content.access_token | ConvertTo-SecureString -AsPlainText -Force))
        $RefreshTokenCredential = [pscredential]::new('refresh_token', $($Content.refresh_token | ConvertTo-SecureString -AsPlainText -Force))
        $Params = @{
            Application = $Application
            AccessTokenCredential = $AccessTokenCredential
            RefreshTokenCredential = $RefreshTokenCredential
            RequestedDate = $RequestedDate
            Response = $Content | Select-Object -property * -ExcludeProperty access_token, refresh_token
            ResponseHeaders = $Result.Headers
            LastRequestDate = $RequestedDate
            Session = $Session
            #ResultObject = $Result
            GUID = [guid]::NewGuid()
        }
        New-GraphOauthAccessToken @Params
    }
}
