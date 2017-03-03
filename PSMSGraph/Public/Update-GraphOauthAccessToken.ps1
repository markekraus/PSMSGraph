<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/9/2017 7:43 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Update-GraphOauthAccessToken.ps1
	===========================================================================
	.DESCRIPTION
		Update-GraphOauthAccessToken Function
#>

<#
    .SYNOPSIS
        Refreshes a Graph Oauth Access Token
    
    .DESCRIPTION
        Requests a refresh of the Graph OAuth Access Token from Graph.
    
    .PARAMETER AccessToken
        Graph OAUth Access Token Object created by Get-GraphOAuthAccessToken.
    
    .PARAMETER BaseUrl
        Base Url for the OAuth Submission end point. This is not required. Defaults to 
            https://login.microsoftonline.com/common/oauth2/token         
    
    .PARAMETER Force
        By default, a Token will not be renewed if it is not expired. Using force will attempt a token refresh the token even if it is not expired.
    
    .PARAMETER PassThru
        Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands. By default, this cmdlet does not generate any output.
    
    .PARAMETER RenewalPeriod
        The renewal period in seconds. The default is 300 (5 minutes). This is the number of seconds before the expiration date that a token will be refreshed. This will prevent the access_token from being expired should the time between the token provider and the local system be offset. If the token is already expired, this will be ignored.

    .EXAMPLE
        PS C:\> $GraphToken = $GraphToken | Update-GraphOAuthAccessToken
    
    .OUTPUTS
        MSGraphAPI.Oauth.AccessToken
    
    .NOTES
        Ses Get-GraphOauthAccessToken for retrieving an OAuth Access Token from Graph

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken   
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken
#>
function Update-GraphOauthAccessToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "", Justification = "Converts plaintext returned from API to secure string.")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Impliments Force param. Updates in memory object only.")]
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken')]
    [OutputType('MSGraphAPI.Oauth.AccessToken')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [pstypename('MSGraphAPI.Oauth.AccessToken')]
        [Alias('Token')]
        [System.Management.Automation.PSObject[]]$AccessToken,
        
        [Parameter(Mandatory = $false)]
        [ValidateScript({
                [system.uri]::IsWellFormedUriString(
                    $_, [System.UriKind]::Absolute
                )
            })]
        [string]$BaseUrl = 'https://login.microsoftonline.com/common/oauth2/token',
        
        [int]$RenewalPeriod = 300,
        
        [switch]$Force,
        
        [switch]$PassThru
    )
    
    process {
        Foreach ($RefreshToken in $AccessToken) {
            Write-Verbose "Processing token '$($RefreshToken.GUID.ToString())'"
            If (!$AccessToken.isExpired -and !$Force -and (get-date) -lt $AccessToken.Expires.addseconds(-$RenewalPeriod)) {
                Write-Verbose "Token is not expired. Skipping"
                Continue
            }
            $Body = @(
                'grant_type=refresh_token'
                '&redirect_uri={0}' -f [System.Web.HttpUtility]::UrlEncode($RefreshToken.Application.RedirectUri)
                '&client_id={0}' -f [System.Web.HttpUtility]::UrlEncode($RefreshToken.Application.ClientID)
                '&client_secret={0}' -f [System.Web.HttpUtility]::UrlEncode($RefreshToken.Application.GetClientSecret())
                '&refresh_token={0}' -f [System.Web.HttpUtility]::UrlEncode($RefreshToken.GetRefreshToken())
                '&resource={0}' -f [System.Web.HttpUtility]::UrlEncode($RefreshToken.Resource)
            ) -join ''
            $Params = @{
                Uri = $BaseUrl
                WebSession = $RefreshToken.Session
                Method = 'POST'
                Body = $Body
            }
            $RequestTime = Get-Date
            try {
                $WebRequest = Invoke-WebRequest @Params
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                Write-Error "Failed to refresh token: $ErrorMessage"
                continue
            }
            try {
                $Content = $WebRequest.Content | ConvertFrom-Json -ErrorAction Stop
            }
            Catch {
                $ErrorMessage = $_.Exception.Message
                $Message = "Failed to convert response from JSON: {0}" -f $ErrorMessage
                Write-Error $Message
                Write-Error $WebRequest.Content
                return
            }
            $RefreshToken.AccessTokenCredential = [pscredential]::new('access_token', $($Content.access_token | ConvertTo-SecureString -AsPlainText -Force))
            $RefreshToken.Response = $Content | Select-Object -property * -ExcludeProperty access_token, refresh_token
            $RefreshToken.RequestedDate = $RequestTime
            
            if ($PassThru) {
                Write-Verbose "Sending Token to the Pipeline"
                $RefreshToken
            }
        }
    }
}