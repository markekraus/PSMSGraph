<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 12:49 PM
     Last Modified: 2/14/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADServicePrincipalAppRoleAssignedTo.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADServicePrincipalAppRoleAssignedTo Function
#>

<#
    .SYNOPSIS
        Returns the App Role Assigmnets for the given Service Principal
    
    .DESCRIPTION
        Returns the App Role Assigmnets for the given Service Principal. this can be used to see what users have been assigned access to an Azure AD SaaS Application (Service Principal)
    
    .PARAMETER ServicePrincipal
        A MSGraphAPI.DirectoryObject.ServicePrincipal object retruned by Get-AADServicePrinicpalbyDisplayName or Get-AADServicePrinicpalbyId
    
    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net
    
    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADAppAssignments = $AADServicePrincipal | Get-AADServicePrincipalAppRoleAssignedTo
    
    .NOTES
        Additional information about the function.
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo
#>
function Get-AADServicePrincipalAppRoleAssignedTo {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo')]
    [OutputType('MSGraphAPI.DirectoryObject.AppRoleAssignment')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.DirectoryObject.ServicePrincipal')][object[]]$ServicePrincipal,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$BaseUrl = 'https://graph.windows.net',
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$APIVersion = '1.6'
    )
    
    process {
        Foreach ($ServiceObject in $ServicePrincipal) {
            if (-not $pscmdlet.ShouldProcess($ServiceObject.objectId)) {
                return
            }
            $AccessToken = $ServiceObject._AccessToken
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $SkipToken = $null
            do {
                $Url = '{0}/{1}/{2}/{3}/{4}?api-version={5}{6}' -f @(
                    $BaseUrl
                    $Tenant
                    'servicePrincipals'
                    $ServiceObject.objectId
                    'appRoleAssignedTo'
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
                    $ErrorMessage = "Unable to query App Assignments for service principal '{0}': {1}" -f $ServiceObject.objectId, $_.Exception.Message
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
