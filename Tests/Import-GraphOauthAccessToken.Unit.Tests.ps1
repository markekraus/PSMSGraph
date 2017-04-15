<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/4/2017 04:35 AM
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Import-GraphOauthAccessToken.Unit.Tests.ps1
	===========================================================================
	.DESCRIPTION
		Unit Tests for Import-GraphOauthAccessToken
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Import-GraphOauthAccessToken'

$TypeName = 'MSGraphAPI.Oauth.AccessToken'

# Create a test OAuth Token and export it
$ExportFile = "{0}\{1}_GraphToken.xml" -f $env:TEMP, $Guid
$ClientID = '12345'
$ClientSecret = '54321'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$ClientCredential = [system.Management.Automation.PSCredential]::new($ClientID, $SecClientSecret)
$AppParams = @{
    Name = 'Unit Test Application'
    Description = 'This is a test of the emergency broadcast system'
    ClientCredential = $ClientCredential
    GUID = 'e2ad918e-dc87-4c23-803c-e67e43e0f217'
    RedirectUri = 'https://localhost'
    Tenant = 'adatum.onmicrosoft.com'
}
$App = New-GraphApplication @AppParams
$Guid = ([System.Guid]::NewGuid()).ToString()
$AToken = '67890'
$SecAtoken = $Atoken | ConvertTo-SecureString -AsPlainText -Force
$AccessTokenCredential = [system.Management.Automation.PSCredential]::new('access_token', $SecAtoken)
$Rtoken = '09876'
$SecRtoken = $Rtoken | ConvertTo-SecureString -AsPlainText -Force
$RefreshTokenCredential = [system.Management.Automation.PSCredential]::new('refresh_token', $SecRtoken)
$TokenParams = $Params = @{
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
$Token = New-GraphOauthAccessToken @TokenParams
$Token | Export-GraphOauthAccessToken -Path $ExportFile

$Params = @{
    Path = $ExportFile
}
$RequiredParams = @(
    'Path'
    'LiteralPath'
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
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns an object with the correct Application properties" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.Application.Name | Should Be $App.Name
        $Object.Application.Description | Should Be $App.Description
        $Object.Application.ClientCredential.GetNetworkCredential().UserName | Should Be $App.ClientCredential.GetNetworkCredential().UserName
        $Object.Application.ClientCredential.GetNetworkCredential().Password | Should Be $App.ClientCredential.GetNetworkCredential().Password
        $Object.Application.GUID | Should Be $APP.GUID
        $Object.Application.RedirectUri | Should Be $APP.RedirectUri
        $Object.Application.Tenant | Should Be $APP.Tenant
    }
    It "Returns an object with the correct Token properties" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.RequestedDate | Should Be $Token.RequestedDate
        $Object.LastRequestDate | Should Be $Token.LastRequestDate
        $Object.AccessTokenCredential.GetNetworkCredential().UserName | Should Be $Token.AccessTokenCredential.GetNetworkCredential().UserName
        $Object.AccessTokenCredential.GetNetworkCredential().Password | Should Be $Token.AccessTokenCredential.GetNetworkCredential().Password
        $Object.RefreshTokenCredential.GetNetworkCredential().UserName | Should Be $Token.RefreshTokenCredential.GetNetworkCredential().UserName
        $Object.RefreshTokenCredential.GetNetworkCredential().Password | Should Be $Token.RefreshTokenCredential.GetNetworkCredential().Password
        $Object.GUID | Should Be $Token.GUID
    }
}

$ExportFile | Remove-Item -Force -Confirm:$false