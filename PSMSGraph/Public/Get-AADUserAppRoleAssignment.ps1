<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 5:17 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADUserAppRoleAssignment.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADUserAppRoleAssignment Function
#>

<#
    .SYNOPSIS
        Returns the App Role Assigmnets for the given user
    
    .DESCRIPTION
        Returns the App Role Assigmnets for the given user. This can be used to see what applications to which Azure AD SaaS Applications (Service Principals) the user has been assigned access.
    
    .PARAMETER User
        A MSGraphAPI.DirectoryObject.User object retruned by Get-AADUser* cmdlets
    
    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net
    
    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADAppAssignments = $AADUser | Get-AADUserAppRoleAssignment 
    
    .NOTES
        Additional information about the function.

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment
#>
function Get-AADUserAppRoleAssignment {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment')]
    [OutputType('MSGraphAPI.DirectoryObject.AppRoleAssignment')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.DirectoryObject.User')]
        [object[]]$User,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$BaseUrl = 'https://graph.windows.net',
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$APIVersion = '1.6'
    )
    
    process {
        Foreach ($UserObject in $User) {
            if (-not $pscmdlet.ShouldProcess($UserObject.objectId)) {
                return
            }
            $AccessToken = $UserObject._AccessToken
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $SkipToken = $null
            do {
                $Url = '{0}/{1}/{2}/{3}/{4}?api-version={5}{6}' -f @(
                    $BaseUrl
                    $Tenant
                    'users'
                    $UserObject.objectId
                    'appRoleAssignments'
                    $APIversion
                    $SkipToken
                )
                $Params = @{
                    Uri = $Url
                    Method = 'GET'
                    AccessToken = $AccessToken
                    ErrorAction = 'Stop'
                }
                try {
                    $Results = Invoke-GraphRequest @Params
                }
                catch {
                    $ErrorMessage = "Unable to query App Assignments for service principal '{0}': {1}" -f $UserObject.objectId, $_.Exception.Message
                    Write-Error $ErrorMessage
                    break
                }
                foreach ($Result in $Results.ContentObject.value) {
                    $OutputObject = $Result.psobject.copy()
                    $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.AppRoleAssignment')
                    $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                    $OutputObject
                }
                $SkipToken = $Results.ContentObject.'odata.nextLink' -replace '^.*skiptoken', '&$skiptoken'
            }
            while ($SkipToken)
        }
    }
}