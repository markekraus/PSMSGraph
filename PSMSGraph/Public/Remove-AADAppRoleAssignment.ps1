<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 1:26 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Remove-AADAppRoleAssignment.ps1
	===========================================================================
	.DESCRIPTION
	    Remove-AADAppRoleAssignment Function
#>

<#
    .SYNOPSIS
        Removes an App Role Assignment
    
    .DESCRIPTION
        Removes an App Role Assignment. This can be used to remove a users access to an Azure AD SaaS Application (Service Principal)
    
    .PARAMETER AppRoleAssignment
        MSGraphAPI.DirectoryObject.AppRoleAssignment object
    
    .PARAMETER BaseUrl
        The Azure AD Graph Base URL. This is not required. Deafult
             https://graph.windows.net
    
    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        		PS C:\> $Results = $AADAppAssignments | Remove-AADAppRoleAssignment
    
    .OUTPUTS
        MSGraphAPI.RequestResult
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Remove-AADAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Add-AADAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo
#>
function Remove-AADAppRoleAssignment {
    [CmdletBinding(ConfirmImpact = 'High',
                   SupportsPaging = $false,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Remove-AADAppRoleAssignment',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.RequestResult')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.DirectoryObject.AppRoleAssignment')][object[]]$AppRoleAssignment,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$BaseUrl = 'https://graph.windows.net',
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$APIVersion = '1.6'
    )
    
    Process {
        foreach ($AppRole in $AppRoleAssignment) {
            if (-not $pscmdlet.ShouldProcess($AppRole.ObjectId)) {
                return
            }
            $AccessToken = $AppRole._AccessToken
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}/{3}/{4}/{5}?api-version={6}' -f @(
                $BaseUrl
                $Tenant
                'users'
                $AppRole.principalId
                'appRoleAssignments'
                [System.Web.HttpUtility]::UrlEncode($AppRole.ObjectId)
                $APIversion
            )
            $Params = @{
                Uri = $Url
                Method = 'DELETE'
                AccessToken = $AccessToken
                ErrorAction = 'Stop'
            }
            try {
                Invoke-GraphRequest @Params
            }
            catch {
                $ErrorMessage = "Unable to remove App Assignments for App Role Assignment '{0}': {1}" -f $AppRole.ObjectId, $_.Exception.Message
                Write-Error $ErrorMessage
                return
            }
        }
        
    }
}
