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
        Retrieves an Azure AD Group by their Object ID
    
    .DESCRIPTION
        Retrieves an Azure AD Group by their Object ID
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER ObjectId
        The group's ObjectID e.g d377e755-9365-400f-ab42-c0bf278c386e

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
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
