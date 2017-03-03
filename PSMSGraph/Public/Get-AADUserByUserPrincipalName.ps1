<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 2:53 PM
     Edited on:     2/16/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADUserByUserPrincipalName.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD User by their UserPrincipalName
    
    .DESCRIPTION
        Retrieves an Azure AD User by their UserPrincipalName
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER UserPrincipalName
        The user's UserPrincipalName e.g bob.testerton@adatum.com

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADUser = Get-AADUserByID -AccessToken $GraphAccessToken -UserPrincipalName bob.testerton@adatum.com
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.User

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByUserPrincipalName
#>
function Get-AADUserByUserPrincipalName {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByUserPrincipalName')]
    [OutputType('MSGraphAPI.DirectoryObject.User')]
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
        [string[]]$UserPrincipalName,
        
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
        foreach ($UPN in $UserPrincipalName) {
            if (-not $pscmdlet.ShouldProcess($UserId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}/{3}?api-version={4}' -f @(
                $BaseUrl
                $Tenant
                'users'
                $UPN
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
                $ErrorMessage = "Unable to query User '{0}': {1}" -f $UPN, $_.Exception.Message
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
