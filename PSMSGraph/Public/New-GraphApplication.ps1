<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 7:34 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	New-GraphApplication.ps1
	===========================================================================
	.DESCRIPTION
		New-GraphApplication Function
#>

<#
    .SYNOPSIS
        Creates a Graph Application object
    
    .DESCRIPTION
        Creates a Graph Application object containing data used by various cmdltes to define the parameters of the App registered on Azure AD. This does not make any calls to Azure or the Gtaph API. The Application will be inbeded in the Graph OAuthToken objects.
        The MSGraphAPI.Application object contains the following properties:
        Name             Name of the Application
        Description      Description of the Application
        UserAgent        The User-Agent header the Application will use to access the Graph API
        ClientID         The Client ID of the Registered Azure App
        RedirectUri      The Redirect URI of the Registered Azure App
        ClientCredential A PS Crednetial containing the Client ID as the username and the Client Secret as the password
        UserCredential   The Reddit Username and password of the developer account used for a Script application
        GUID             A GUID to identitfy the application wihin this module (not consumed or used by Azure or Graph)
    
    .PARAMETER Name
        Name of the Graph App. This does not need to match the name registered on Azure. It is used for convenient identification and ducomentation purposes only.
    
    .PARAMETER ClientCredential
        A PScredential object containging the Client ID as the Username and the Client Secret as the password.
    
    .PARAMETER RedirectUri
        Redirect URI as registered on Azure for the App. This must match exactly as entered in the App definition or authentication will fail.

    .PARAMETER Tenant
        The Azure/Office365 Tenant ID. e.g. adadtum.onmicrosft.com
    
    .PARAMETER Description
        Description of the Graph App. This is not required or used for anything. It is provided for convenient identification and documentation purposes only.
    
    .PARAMETER GUID
        A GUID to identify the application. If one is not perovided, a new GUID will be generated.
    
    .EXAMPLE
        PS C:\> $ClientCredential = Get-Credential
        PS C:\> $Params = @{
        Name = 'MyGraphApp'
        Description = 'My Graph Application!'
        ClientCredential = $ClientCredential
        RedirectUri = 'https://adataum/ouath?'
        UserAgent = 'Windows:PowerShell:GraphApplication'
        }
        PS C:\> $GraphApp = New-GraphApplication @Params
    
    .OUTPUTS
        MSGraphAPI.Application
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication
    .Link
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication
#>
function New-GraphApplication {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Creates in memory object only.")]
    [CmdletBinding(ConfirmImpact = 'None',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication')]
    [OutputType('MSGraphAPI.Application')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('AppName')]
        [string]$Name,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ClientInfo')]
        [System.Management.Automation.PSCredential]$ClientCredential,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                [system.uri]::IsWellFormedUriString(
                    $_, [System.UriKind]::Absolute
                )
            })]
        [string]$RedirectUri,
        
        [Parameter(Mandatory = $True,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$Tenant,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [System.Guid]$GUID = [system.guid]::NewGuid()
    )
    
    Process {
        
        [pscustomobject]@{
            PSTypeName = 'MSGraphAPI.Application'
            Name = $Name
            Description = $Description
            ClientCredential = $ClientCredential
            RedirectUri = $RedirectUri
            Tenant = $Tenant
            GUID = $GUID
        }
    }
}