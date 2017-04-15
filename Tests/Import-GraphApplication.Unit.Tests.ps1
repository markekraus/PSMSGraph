<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/4/2017 04:04 AM
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Import-GraphApplication.Unit.Tests.ps1
	===========================================================================
	.DESCRIPTION
		Unit Tests for Import-GraphApplication
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Import-GraphApplication'

$TypeName = 'MSGraphAPI.Application'

# Create a test application and export it
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
$ExportFile = "{0}\{1}_GraphApplication.xml" -f $env:TEMP, $Guid
$App | Export-GraphApplication -Path $ExportFile

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
    It "Returns an object with the correct properties" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.Name | Should Be $App.Name
        $Object.Description | Should Be $App.Description
        $Object.ClientCredential.GetNetworkCredential().UserName | Should Be $App.ClientCredential.GetNetworkCredential().UserName
        $Object.ClientCredential.GetNetworkCredential().Password | Should Be $App.ClientCredential.GetNetworkCredential().Password
        $Object.GUID | Should Be $APP.GUID
        $Object.RedirectUri | Should Be $APP.RedirectUri
        $Object.Tenant | Should Be $APP.Tenant
    }
}

$ExportFile | Remove-Item -Force -Confirm:$false