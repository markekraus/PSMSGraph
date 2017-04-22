<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 5:53 AM
     Edited on:     4/22/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Get-AADGroupByDisplayName.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADGroupByDisplayName Function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD Group by the provided Display name
    
    .DESCRIPTION
        Searches Azure Active Directory Graph API for a Group by the provided display name. 
        The provided displayname must be a full case-insensitive match. Partial matches and
        wildcards are not supported. A MSGraphAPI.DirectoryObject.Group object will be
        returned for the matching group.

        Get-AADGroupByDisplayName requires a MSGraphAPI.Oauth.AccessToken issued for the 
        https://graph.windows.net resource. See the Get-GraphOauthAccessToken help for
        more information.

        Get-Help -Name Get-GraphOauthAccessToken -Parameter Resource
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
        Access Token must be issued for the https://graph.windows.net resource.
    
    .PARAMETER DisplayName
        The Group's Display Name. This must be an exact case-insensitive match and does not 
        support wildcards or partial matches.

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        Version of the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADGroup = Get-AADGroupByDisplayName -AccessToken $GraphAccessToken -DisplayName 'Adataum Finance'
    
    .OUTPUTS
       MSGraphAPI.DirectoryObject.Group

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName    

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken

    .LINK
        https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/groups-operations
    
    .LINK
        https://msdn.microsoft.com/en-us/library/azure/ad/graph/howto/azure-ad-graph-api-supported-queries-filters-and-paging-options#filter
#>
function Get-AADGroupByDisplayName {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName')]
    [OutputType('MSGraphAPI.DirectoryObject.Group')]
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
        foreach ($GroupName in $DisplayName) {
            if (-not $pscmdlet.ShouldProcess($ServiceId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}?api-version={3}&$filter=displayName+eq+%27{4}%27' -f @(
                $BaseUrl
                $Tenant
                'groups'
                $APIversion
                [System.Web.HttpUtility]::UrlEncode($GroupName)
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
                $ErrorMessage = "Unable to query Group '{0}': {1}" -f $GroupName, $_.Exception.Message
                Write-Error -Message $ErrorMessage -Exception $_.Exception
                return
            }
            foreach ($ServiceObject in $Result.ContentObject.value) {
                $OutputObject = $ServiceObject.psobject.copy()
                $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.Group')
                $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                $OutputObject
            }
        }
    }
}
