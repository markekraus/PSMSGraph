<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 6:38 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADUserAll.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADUserAll Function
#>

<#
    .SYNOPSIS
        Returns All Azure AD Users
    
    .DESCRIPTION
        Returns All Azure AD Users
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER Filter
        The Azure AD Graph API $filter to be applied. The string will be url encoded.
    
    .PARAMETER APIVersion
        version of the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADUsers = Get-AADUserAll -AccesToken $GraphAccessToken
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.User
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAll
#>
function Get-AADUserAll {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAll')]
    [OutputType('MSGraphAPI.DirectoryObject.User')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.Oauth.AccessToken')]
        $AccessToken,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$filter,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$BaseUrl = 'https://graph.windows.net',
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$APIVersion = '1.6'
    )
    
    process {
        if (-not $pscmdlet.ShouldProcess($AccessToken.GUID)) {
            return
        }
        $Application = $AccessToken.Application
        $Tenant = $Application.Tenant
        $SkipToken = $null
        do {
            $Url = '{0}/{1}/{2}?api-version={3}{4}{5}' -f @(
                $BaseUrl
                $Tenant
                'users'
                $APIversion
                '&$filter={0}' -f [System.Web.HttpUtility]::UrlEncode($Filter)
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
                $ErrorMessage = "Unable to query members for user: {0}" -f $_.Exception.Message
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