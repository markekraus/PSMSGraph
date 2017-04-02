<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 6:02 AM
     Edited on:     3/30/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADGroupMember.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADGroupMember Function
#>

<#
    .SYNOPSIS
        Returns the members for the given Group
    
    .DESCRIPTION
        Returns the members for the given Group
    
    .PARAMETER Group
        A MSGraphAPI.DirectoryObject.Group object retruned by Get-AADGroup* cmdlets
    
    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net
    
    .PARAMETER APIVersion
        version of the API to use. Default is 1.6
    
    .PARAMETER ResultsPerPage
        The number of results to request from the API per call. This is the '$top' API query filter. Default is 100. Valid Range is 1-999.

        This will not limit the number of resutls retruned by the command.
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.User

    .INPUTS
        MSGraphAPI.DirectoryObject.Group
    
    .EXAMPLE
        PS C:\> $AADGroupMembers = $AADGroup | Get-AADGroupMembers 
    
    .NOTES
        Additional information about the function.

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName
#>
function Get-AADGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember')]
    [OutputType('MSGraphAPI.DirectoryObject.User')]
    [Alias('Get-AADGroupMembers')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.DirectoryObject.Group')]
        [object[]]$Group,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$BaseUrl = 'https://graph.windows.net',
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$APIVersion = '1.6',
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1,999)]
        [int]$ResultsPerPage = 100
    )
    
    process {
        Foreach ($GroupObject in $Group) {
            if (-not $pscmdlet.ShouldProcess($GroupObject.objectId)) {
                return
            }
            $AccessToken = $GroupObject._AccessToken
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $SkipToken = $null
            do {
                $Url = '{0}/{1}/{2}/{3}/{4}?api-version={5}{6}{7}' -f @(
                    $BaseUrl
                    $Tenant
                    'groups'
                    $GroupObject.objectId
                    'members'
                    $APIversion
                    '&$top={0}' -f $ResultsPerPage
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
                    $ErrorMessage = "Unable to query members for group '{0}': {1}" -f $GroupObject.objectId, $_.Exception.Message
                    Write-Error $ErrorMessage
                    break
                }
                foreach ($Result in $Results.ContentObject.value) {
                    $OutputObject = $Result.psobject.copy()
                    $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.User')
                    $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                    $OutputObject
                }
                $SkipToken = $Results.ContentObject.'odata.nextLink' -replace '^.*skiptoken', '&$skiptoken'
            }
            while ($SkipToken)
        }
    }
}