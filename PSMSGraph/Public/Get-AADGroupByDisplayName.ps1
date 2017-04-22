<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/14/2017 5:53 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-AADGroupByDisplayName.ps1
	===========================================================================
	.DESCRIPTION
		Get-AADGroupByDisplayName Function
#>

<#
    .SYNOPSIS
        Retrieves an Azure AD Group by the Display name
    
    .DESCRIPTION
        Retrieves an Azure AD Group by the Display Name
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER DisplayName
        The Group's Display Name. This must be an exact match and does not support wildcards

    .PARAMETER BaseURL
        The Azure AD Graph Base URL. This is not required. Deafult 
            https://graph.windows.net

    .PARAMETER APIVersion
        version og the API to use. Default is 1.6
    
    .EXAMPLE
        PS C:\> $AADGroup = Get-AADGroupByDisplayName -AccessToken $GraphAccessToken -DisplayName 'Adataum Finance'
    
    .OUTPUTS
        MSGraphAPI.DirectoryObject.ServicePrincipal

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName    

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID
#>
function Get-AADGroupByDisplayName {
    [CmdletBinding(SupportsShouldProcess = $true,
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName')]
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
        [string[]]$DisplayName,
        
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
        foreach ($GroupName in $DisplayName) {
            if (-not $pscmdlet.ShouldProcess($ServiceId)) {
                return
            }
            $Application = $AccessToken.Application
            $Tenant = $Application.Tenant
            $Url = '{0}/{1}/{2}?api-version={3}&$filter=displayName+eq+%27{4}%27' -f @(
                $BaseUrl
                $Tenant
                'groups'
                $APIversion
                [System.Web.HttpUtility]::UrlEncode($GroupName)
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
                $ErrorMessage = "Unable to query Group '{0}': {1}" -f $GroupName, $_.Exception.Message
                Write-Error -Message $ErrorMessage -Exception $_.Exception
                return
            }
            foreach ($ServiceObject in $Result.ContentObject.value) {
                $OutputObject = $ServiceObject.psobject.copy()
                $OutputObject.psobject.TypeNames.Insert(0, 'MSGraphAPI.DirectoryObject.Group')
                $OutputObject | Add-Member -MemberType NoteProperty -Name _AccessToken -Value $AccessToken
                $OutputObject
            }
        }
    }
}
