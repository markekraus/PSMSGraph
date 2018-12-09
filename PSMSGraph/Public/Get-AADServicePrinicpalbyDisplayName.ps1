<#
    .NOTES
    ===========================================================================
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/13/2017 12:20 PM
     Last Edited:   2/14/2017
     Created by:   	Mark Kraus
     Organization: 	Mitel
     Filename:     	Get-AADServicePrinicpalbyDisplayName.ps1
    ===========================================================================
    .DESCRIPTION
        Get-AADServicePrinicpalbyDisplayName Function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD ServicePrincipal by the Display name

    .DESCRIPTION
        Retrieves an Azure AD ServicePrincipal by the Display Name

    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.

    .PARAMETER DisplayName
        The ServicePrincipal's Display Name. This must be an exact match and does not support wildcards

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6

    .EXAMPLE
        PS C:\> $AADServicePrincipal = Get-AADServicePrincipalByDisplayName -AccessToken $GraphAccessToken -DisplayName 'Contoso Web App'

    .OUTPUTS
        MSGraphAPI.DirectoryObject.ServicePrincipal

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyDisplayName
#>
function Get-AADServicePrinicpalbyDisplayName {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyDisplayName')]
    [OutputType('MSGraphAPI.DirectoryObject.ServicePrincipal')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.Oauth.AccessToken')]
        $AccessToken,

        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$DisplayName,

        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl = 'https://graph.windows.net',

        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$APIversion = '1.6'

    )

    process {
        foreach ($ServiceName in $DisplayName) {
            if (-not $pscmdlet.ShouldProcess($ServiceId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}?api-version={3}&$filter=displayName+eq+%27{4}%27' -f @(
                $BaseUrl
                $Tenant
                'servicePrincipals'
                $APIversion
                [System.Web.HttpUtility]::UrlEncode($ServiceName)
            )
            $Params = @{
                Uri = $Url
                Method = 'GET'
                AccessToken = $AccessToken
                ErrorAction = 'Stop'
            }
            try {
                $Result = Invoke-GraphRequest @Params
            }
            catch {
                $ErrorMessage = "Unable to query User '{0}': {1}" -f $UserId, $_.Exception.Message
                Write-Error $ErrorMessage
                return
            }
            foreach ($ServiceObject in $Result.ContentObject.value) {
                $OutputObject = $ServiceObject.psobject.copy()
                $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.ServicePrincipal')
                $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                $OutputObject
            }
        }
    }
}
