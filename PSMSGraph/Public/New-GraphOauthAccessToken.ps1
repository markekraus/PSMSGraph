<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/9/2017 5:46 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	New-GraphOauthAccessToken.ps1
	===========================================================================
	.DESCRIPTION
		New-GraphOauthAccessToken Function
#>

<#
    .SYNOPSIS
        Creates an MSGraphAPI.Oauth.AccessToken Object
    
    .DESCRIPTION
        This creates a MSGraphAPI.Oauth.AccessToken object. This only creates the objects used in this module. It does not make any API calls. To retrieve an OAuth Access Token, use Get-GraphOauthAccessToken
    
    .PARAMETER Application
        A MSGraphAPI.Application object. See New-GraphApplication
    
    .PARAMETER AccessTokenCredential
        A PSCredential Object containing the access_token as a password. Username is ignored.
    
    .PARAMETER RefreshTokenCredential
        A PSCredential Object containing the refresh_token as a password. Username is ignored.
    
    .PARAMETER RequestedDate
        The date and time the current access_token was requested
    
    .PARAMETER Response
        A PSObject containing the last response from the API converted from JSON and striped of the access_token and refresh_token
    
    .PARAMETER ResponseHeaders
        A headers dictionary retruned from the API.
    
    .PARAMETER LastRequestDate
        A datetime of the last API call made using thie token.
    
    .PARAMETER Session
        The Session object used to access the API. This creates a consistent experience accross API cals by mimicing a browser session.
    
    .PARAMETER GUID
        A GUID to identify the Graph OAuth Token Object. If one is not provided, a new GUID will be generated. This is used for internal reference only and is not consumed by the Graph API.
    
    .EXAMPLE
        		PS C:\> New-GraphOauthAccessToken -Application $GraphApp -AccessTokenCredential $AccessTokenCredential -RefreshTokenCredential $RefreshTokenCredential -RequestedDate (get-date) -Response $Response -ResponseHeaders $Result.Headers -LastRequestDate (get-date)
    
    .NOTES
        See Get-GraphOauthAccessToken
    
    .OUTPUTS
        MSGraphAPI.Oauth.AccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken
#>
function New-GraphOauthAccessToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Creates in memory object only.")]
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphOauthAccessToken')]
    [OutputType('MSGraphAPI.Oauth.AccessToken')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.Application')]$Application,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$AccessTokenCredential,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$RefreshTokenCredential,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [datetime]$RequestedDate,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSObject]$Response,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSObject]$ResponseHeaders,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [datetime]$LastRequestDate,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipeline = $false)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [guid]$GUID = [Guid]::NewGuid()
    )
    
    Process {
        [pscustomobject]@{
            PSTypeName = 'MSGraphAPI.Oauth.AccessToken'
            Application = $Application
            AccessTokenCredential = $AccessTokenCredential
            RefreshTokenCredential = $RefreshTokenCredential
            RequestedDate = $RequestedDate
            Response = $Response | Select-Object -property * -ExcludeProperty access_token, refresh_token
            ResponseHeaders = $ResponseHeaders
            LastRequestDate = $LastRequestDate
            Session = $Session
            GUID = $GUID
        }
    }
}
