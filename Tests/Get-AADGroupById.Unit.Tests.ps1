<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/11/2017 04:20 AM
     Edited on:     4/22/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Get-AADGroupById.Unit.Tests.ps1
	===========================================================================
	.DESCRIPTION
		Unit Tests for Get-AADGroupById
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Get-AADGroupById'

$TypeName = 'MSGraphAPI.DirectoryObject.Group'

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


$Params = @{
    ObjectId = 'c57cdc98-0dcd-4f90-a82f-c911b288bab9'
    AccessToken = $Token
}
$RequiredParams = @(
    'ObjectId'
    'AccessToken'
)
$VerifyUrl = @(
     'https://graph.windows.net/'
     $AppParams.Tenant
     '/groups/'
     'c57cdc98-0dcd-4f90-a82f-c911b288bab9'
     '?api-version=1.6'
) -Join ''
$VerifyBadUrl = @(
     'https://graph.windows.net/'
     $AppParams.Tenant
     '/groups/'
     'BadGroupId'
     '?api-version=1.6'
) -Join ''

$ValidUrls = @(
    $VerifyUrl
    $VerifyBadUrl
)
# https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/groups-operations
$Global:AADGroupJSON = @'
{
  "odata.type": "Microsoft.DirectoryServices.Group",
  "objectType": "Group",
  "objectId": "c57cdc98-0dcd-4f90-a82f-c911b288bab9",
  "deletionTimestamp": null,
  "description": "Marketing Group",
  "dirSyncEnabled": null,
  "displayName": "Marketing",
  "lastDirSyncTime": null,
  "mail": null,
  "mailNickname": "cdf76b17-0734-41bc-9c24-9a7af93f3502",
  "mailEnabled": false,
  "onPremisesSecurityIdentifier": null,
  "provisioningErrors": [],
  "proxyAddresses": [],
  "securityEnabled": true
}
'@

Describe $Command -Tags Unit {
    # Mock to send error when the Uri sent to Invoke-GraphRequest
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$ValidUrls -notcontains $Uri} -MockWith {
       Throw "$Uri not in `r`n$($ValidUrls -join "`r`n ")"
    }
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $ValidUrls[0]} -MockWith {
        $MockResponse = [pscustomobject]@{
            ContentObject = [pscustomobject]@{
                Value = $Global:AADGroupJSON | ConvertFrom-Json
            }
        }
        return $MockResponse
    }
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $ValidUrls[1]} -MockWith {
        Throw 'Invalid Group'
    }
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
    It "Returns a $TypeName Object" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns a $TypeName object with a valid _AccessToken property" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object._AccessToken.GUID | should be $Token.GUID
    }
    It 'Provides friendly errors' {
         $LocalParams = $Params.psobject.Copy()
         $LocalParams.ObjectId = 'BadGroupId'
        { & $Command @LocalParams -ErrorAction Stop } | Should not throw 'Unable to query Group'
    }
}

Remove-Variable -Name 'AADGroupJSON' -Scope 'Global'