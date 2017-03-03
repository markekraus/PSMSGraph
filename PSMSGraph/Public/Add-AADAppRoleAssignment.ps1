<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 1:59 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Add-AADAppRoleAssignment.ps1
	===========================================================================
	.DESCRIPTION
		Add-AADAppRoleAssignment Function
#>

<#
    .SYNOPSIS
        Adds an Azure AD App Role Assignment for the given user to the given servcie principal
    
    .DESCRIPTION
        Adds an Azure AD App Role Assignment for the given user to the given servcie principal
    
    .PARAMETER ServicePrincipal
        MSGraphAPI.DirectoryObject.ServicePrincipal retruned by the Get-AADServicePrincipal* cmdlets
    
    .PARAMETER User
        MSGraphAPI.DirectoryObject.User object returnedfrom the Get-AADUser* cmdltes
    
    .PARAMETER BaseUrl
        The Azure AD Graph Base URL. This is not required. Deafult
             https://graph.windows.net
    
    .PARAMETER APIVersion
        version og the API to use. Default is 1.6

    .PARAMETER RoleID
        This is the Role ID that will be added for the user. The dafault is 00000000-0000-0000-0000-000000000000
    
    .EXAMPLE
        PS C:\> Add-AADAppRoleAssignment -ServicePrincipal $AADServicePrincipal -User $AADUser
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.AppRoleAssignment

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Add-AADAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Remove-AADAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo
#>
function Add-AADAppRoleAssignment {
    [CmdletBinding(ConfirmImpact = 'Medium',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Add-AADAppRoleAssignment',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.DirectoryObject.AppRoleAssignment')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [object[]]$ServicePrincipal,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [object[]]$User,
        
        [string]$BaseURL = 'https://graph.windows.net',
        
        [string]$APIVersion = '1.6',
        
        [string]$RoleID = '00000000-0000-0000-0000-000000000000'
    )
    Process {
        foreach ($ServiceObject in $ServicePrincipal) {
            foreach ($UserObject in $User) {
                $ProcessText = "User: '{0}' ServicePrincipal: '{1}' RoleID: '{2}'" -f $UserObject.ObjectId, $ServiceObject.ObjectId, $RoleID
                if (-not $pscmdlet.ShouldProcess($ProcessText)) {
                    continue
                }
                $AccessToken = $ServiceObject._AccessToken
                $Application = $AccessToken.Application
                $Tenant = $Application.Tenant
                $Body = @{
                    id = $RoleID
                    resourceId = $ServiceObject.ObjectId
                    principalId = $UserObject.ObjectId
                } | ConvertTo-Json
                $Url = '{0}/{1}/{2}/{3}/{4}?api-version={5}' -f @(
                    $BaseUrl
                    $Tenant
                    'users'
                    $UserObject.ObjectId
                    'appRoleAssignments'
                    $APIversion
                )
                $Params = @{
                    Uri = $Url
                    Body = $Body
                    Method = 'POST'
                    AccessToken = $AccessToken
                    ErrorAction = 'Stop'
                }
                try {
                    $Result = Invoke-GraphRequest @Params
                }
                catch {
                    $ErrorMessage = "Unable to add App Assignments for User '{0}' to ServicePrincipal '{1}': {2}" -f $UserObject.ObjectId, $ServiceObject.ObjectId, $_.Exception.Message
                    Write-Error $ErrorMessage
                    return
                }
                $OutputObject = $Result.ContentObject.psobject.copy()
                $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.AppRoleAssignment')
                $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                $OutputObject
            }
        }
    }
}