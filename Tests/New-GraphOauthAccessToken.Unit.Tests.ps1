<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/27/2017 4:42 AM
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Unit Tests for New-GraphOauthAccessToken
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'New-GraphOauthAccessToken'

$TypeName = 'MSGraphAPI.Oauth.AccessToken'
$ClientID = '12345'
$ClientSecret = '54321'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$ClientCredential = [system.Management.Automation.PSCredential]::new($ClientID, $SecClientSecret)
$Params = @{
    Name = 'Unit Test Application'
    Description = 'This is a test of the emergency broadcast system'
    ClientCredential = $ClientCredential
    GUID = 'e2ad918e-dc87-4c23-803c-e67e43e0f217'
    RedirectUri = 'https://localhost'
    Tenant = 'adatum.onmicrosoft.com'
}
$App = New-GraphApplication @Params

$AToken = '67890'
$SecAtoken = $Atoken | ConvertTo-SecureString -AsPlainText -Force
$AccessTokenCredential = [system.Management.Automation.PSCredential]::new('access_token', $SecAtoken)
$Rtoken = '09876'
$SecRtoken = $Rtoken | ConvertTo-SecureString -AsPlainText -Force
$RefreshTokenCredential = [system.Management.Automation.PSCredential]::new('refresh_token', $SecRtoken)

$Params = @{
    'Application' = $App
    'AccessTokenCredential' = $AccessTokenCredential
    'RefreshTokenCredential' = $RefreshTokenCredential
    'RequestedDate' = Get-Date
    'Response' = [pscustomobject]@{TestResponse = 'Test'}
    'ResponseHeaders' = [pscustomobject]@{ TestHeaders = 'Test' }
    'LastRequestDate' = get-date
    'GUID' = '1c6e3c87-8f77-435c-911d-3e97588918d0'
    'Session' = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
}
$RequiredParams = @(
    'Application'
    'AccessTokenCredential'
    'RefreshTokenCredential'
    'RequestedDate'
    'Response'
    'ResponseHeaders'
    'LastRequestDate'
)
Describe $Command -Tags Unit {
    It 'Does not have errors when passed required parameters' {
        $LocalParams = $Params.psobject.Copy()
        { & $Command @LocalParams -ErrorAction Stop } | Should not throw
    }
    Foreach ($RequiredParam in $RequiredParams) {
        It "Requires the $RequiredParam parameter" {
            ((Get-Command $Command).Parameters[$RequiredParam].Attributes |
                Where-Object { $_ -is [parameter] }).Mandatory |
            Should be $true
        }
    }
    It "Emits a $TypeName Object" {
        (Get-Command $Command).OutputType.Name.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Creates a $TypeName Object" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams -ErrorAction SilentlyContinue | Select-Object -First 1
        $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
}