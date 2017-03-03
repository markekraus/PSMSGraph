<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 12:15 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADServicePrinicpalbyId.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADServicePrinicpalbyId Function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD ServicePrincipal by the Object ID
    
    .DESCRIPTION
        Retrieves an Azure AD ServicePrincipal by the Object ID
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER ObjectId
        The ServicePrincipal's ObjectID e.g d377e755-9365-400f-ab42-c0bf278c386e

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADUser = Get-AADServicePrincipalByID -AccessToken $GraphAccessToken -ObjectID d377e755-9365-400f-ab42-c0bf278c386e
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.ServicePrincipal

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyId
#>
function Get-AADServicePrinicpalbyId {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyId')]
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
        [string[]]$ObjectId,
        
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
        foreach ($ServiceId in $ObjectId) {
            if (-not $pscmdlet.ShouldProcess($ServiceId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}/{3}?api-version={4}' -f @(
                $BaseUrl
                $Tenant
                'servicePrincipals'
                $ServiceId
                $APIversion
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
            $OutputObject = $Result.ContentObject.psobject.copy()
            $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.ServicePrincipal')
            $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
            $OutputObject
        }
    }
}
