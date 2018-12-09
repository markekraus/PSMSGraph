<#
    .NOTES
    ===========================================================================
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/8/2017 10:26 AM
     Edited on::    4/22/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	Get-GraphOauthAccessToken.ps1
    ===========================================================================
    .DESCRIPTION
        Get-GraphOauthAccessToken Function
#>

<#
    .SYNOPSIS
        Retieves an OAuth Access Token from Microsoft

    .DESCRIPTION
        Takes an OAuth Acces Authorization code returned from Get-GraphOauthAuthorizationCode and
        requests an OAuth Access Token for the provided resource from Microsoft. A
        MSGraphAPI.Oauth.AccessToken object is returned. This object is required for making calls
        to Invoke-GraphRequest and many other functions provided by this module.


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

        If you need to access more than one resrouce, you will need to request multiple OAuth Access
        Tokens and use the correct tokens for the correct endpoints.

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
        See Get-GraphOauthAuthorizationCode for obtaining a OAuth Authorization code.
        See Export-GraphOauthAccessToken for exporting Graph Acess Token Objects
        See Import-GraphOauthAccessToken for importing exported Graph AcessToken Objects
        See Update-GraphOauthAccessToken for refreshing the Graph Access Token

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode
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
            $_.Exception.
                psobject.
                TypeNames.
                Insert(0,'MSGraphAPI.Oauth.Exception')
            Write-Error -Exception $_.Exception
            return
        }
        try {
            $Content = $Result.Content | ConvertFrom-Json -ErrorAction Stop
        }
        Catch {
            $Params = @{
                MemberType = 'NoteProperty'
                Name = 'Respone'
                Value = $Result
            }
            $_.Exception | Add-Member @Params
            Write-Error -Exception $_.Exception
            return
        }
        $SecureAccessToken = $Content.access_token | ConvertTo-SecureString -AsPlainText -Force
        $SecureRefreshToken = $Content.refresh_token | ConvertTo-SecureString -AsPlainText -Force
        $AccessTokenCredential = [pscredential]::new('access_token', $SecureAccessToken )
        $RefreshTokenCredential = [pscredential]::new('refresh_token', $SecureRefreshToken)
        $Params = @{
            Application = $Application
            AccessTokenCredential = $AccessTokenCredential
            RefreshTokenCredential = $RefreshTokenCredential
            RequestedDate = $RequestedDate
            Response = $Content | Select-Object -property * -ExcludeProperty access_token, refresh_token
            ResponseHeaders = $Result.Headers
            LastRequestDate = $RequestedDate
            Session = $Session
            GUID = [guid]::NewGuid()
        }
        New-GraphOauthAccessToken @Params
    }
}
