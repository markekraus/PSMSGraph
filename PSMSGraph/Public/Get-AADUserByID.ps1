<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 10:38 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADUserByID.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADUserByID function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD User by their Object ID
    
    .DESCRIPTION
        Retrieves an Azure AD User by their Object ID
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER ObjectId
        The user's ObjectID e.g d377e755-9365-400f-ab42-c0bf278c386e

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADUser = Get-AADUserByID -AccessToken $GraphAccessToken -ObjectID d377e755-9365-400f-ab42-c0bf278c386e
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.User
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByID
#>
function Get-AADUserByID {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByID')]
    [OutputType('MSGraphAPI.DirectoryObject.User')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.Oauth.AccessToken')]$AccessToken,
        
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
        foreach ($UserId in $ObjectId) {
            if (-not $pscmdlet.ShouldProcess($UserId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant            
            $Url = '{0}/{1}/{2}/{3}?api-version={4}' -f @(
                $BaseUrl
                $Tenant
                'users'
                $UserId
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
            $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.User')
            $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
            $OutputObject
        }
    }
}
