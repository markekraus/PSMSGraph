<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 6:08 AM
     Edited On:     2/23/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Get-AADGroupById.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADGroupById Function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD Group by hte provided Object ID
    
    .DESCRIPTION
        Searches Azure Active Directory Graph API for a Group by the provided Object ID. 
        The provided Object ID must be a full case-insensitive match. Partial matches and
        wildcards are not supported. The Object ID is the Azure AD Object ID and not the
        ObjectGUID synced from an On-prem AD. A MSGraphAPI.DirectoryObject.Group object will 
        be returned for the matching group.

        Get-AADGroupById requires a MSGraphAPI.Oauth.AccessToken issued for the 
        https://graph.windows.net resource. See the Get-GraphOauthAccessToken help for
        more information.

        Get-Help -Name Get-GraphOauthAccessToken -Parameter Resource
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
        Access Token must be issued for the https://graph.windows.net resource.
    
    .PARAMETER ObjectId
        The group's Azure AD ObjectID e.g d377e755-9365-400f-ab42-c0bf278c386e
        This is not the ObjectGUID synced from an On-prem AD

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        Version of the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADGroup = Get-AADGroupByID -AccessToken $GraphAccessToken -ObjectID d377e755-9365-400f-ab42-c0bf278c386e
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.Group

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken

    .LINK
        https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/groups-operations
    
    .LINK
        https://msdn.microsoft.com/en-us/library/azure/ad/graph/howto/azure-ad-graph-api-supported-queries-filters-and-paging-options#filter 
#>
function Get-AADGroupByID {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID')]
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
        foreach ($GroupId in $ObjectId) {
            if (-not $pscmdlet.ShouldProcess($GroupId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}/{3}?api-version={4}' -f @(
                $BaseUrl
                $Tenant
                'groups'
                $GroupId
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
                $ErrorMessage = "Unable to query Group '{0}': {1}" -f $GroupId, $_.Exception.Message
                Write-Error -Message $ErrorMessage -Exception $_.Exception
                return
            }
            $OutputObject = $Result.ContentObject.psobject.copy()
            $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.Group')
            $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
            $OutputObject
        }
    }
}
