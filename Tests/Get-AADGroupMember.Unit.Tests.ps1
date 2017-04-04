<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/2/2017 10:27 AM
     Edited on:     4/4/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Get-AADGroupMember.Unit.Tests.ps1
	===========================================================================
	.DESCRIPTION
		Unit Tests for Get-AADGroupMember
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Get-AADGroupMember'

$TypeName = 'MSGraphAPI.DirectoryObject.User'

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

$Group = [pscustomobject]@{
    PSTypeName = 'MSGraphAPI.DirectoryObject.Group'
    objectId = '2147adfd-3000-4df2-b39f-135835535fb9'
    _AccessToken = $Token
}
$GroupMultiPage = [pscustomobject]@{
    PSTypeName = 'MSGraphAPI.DirectoryObject.Group'
    objectId = '15532076-a044-4c72-a9ed-64966ba50d06'
    _AccessToken = $Token
}
$Params = @{
    Group = $Group
}
$RequiredParams = @(
    'Group'
)
$VerifyUrl = @(
     'https://graph.windows.net/'
     $AppParams.Tenant
     '/groups/'
     $Group.objectId
     '/members?'
     'api-version=1.6'
     '&$top=100'
) -Join ''
$VerifyUrlMultiPage1 = @(
     'https://graph.windows.net/'
     $AppParams.Tenant
     '/groups/'
     $GroupMultiPage.objectId
     '/members?'
     'api-version=1.6'
     '&$top=100'
) -Join ''
$VerifyUrlMultiPage2 = @(
     'https://graph.windows.net/'
     $AppParams.Tenant
     '/groups/'
     $GroupMultiPage.objectId
     '/members?'
     'api-version=1.6'
     '&$top=100'
     '&$skiptoken=page2'
) -Join ''
$ValidUrls = @(
    $VerifyUrl
    $VerifyUrlMultiPage1
    $VerifyUrlMultiPage2
)

Describe $Command -Tags Unit {
    # Mock to send error when the Uri sent to Invoke-GraphRequest
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$ValidUrls -notcontains $Uri} -MockWith {
       Throw "$Uri not in `r`n$($ValidUrls -join "`r`n ")"
    }
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $ValidUrls[0]} -MockWith {
        $MockResponse = [pscustomobject]@{
            ContentObject = [pscustomobject]@{
                Value = @(
                    [pscustomobject]@{
                        objectId = '596f00c9-9046-4f24-9768-cbff0202c05a'
                        DisplayName = 'Member1'
                    }
                    [pscustomobject]@{
                        objectId = 'd9b21eea-fb8b-4a69-a549-48cab600c35a'
                        DisplayName = 'Member2'
                    }
                )
            }
        }
        return $MockResponse
    }
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $ValidUrls[1]} -MockWith {
        $MockResponse= [pscustomobject]@{
            ContentObject = [pscustomobject]@{
                'odata.nextLink' = 'hsagkgbkgakugksaskiptoken=page2'
                Value = @(
                    [pscustomobject]@{
                        objectId = '596f00c9-9046-4f24-9768-cbff0202c05a'
                        DisplayName = 'Member1'
                    }
                    [pscustomobject]@{
                        objectId = 'd9b21eea-fb8b-4a69-a549-48cab600c35a'
                        DisplayName = 'Member2'
                    }
                )
            }
        }
        return $MockResponse
    }
    Mock -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $ValidUrls[2]} -MockWith {
        $MockResponse = [pscustomobject]@{
            ContentObject = [pscustomobject]@{
                Value = @(
                    [pscustomobject]@{
                        objectId = '355e6c94-491d-46e9-baac-8c6af2bad943'
                        DisplayName = 'Member3'
                    }
                    [pscustomobject]@{
                        objectId = 'e36ce62f-d005-4b47-8312-6de0df22bfce'
                        DisplayName = 'Member4'
                    }
                )
            }
        }
        return $MockResponse
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
    It "Creates a $TypeName Object" {
        $LocalParams = $Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
    it "Paginates without error" {
        $LocalParams = $Params.psobject.Copy()
        $LocalParams.Group = $GroupMultiPage
        { & $Command @LocalParams -ErrorAction Stop } | Should not throw
    }
    It "Called page1" {
        Assert-MockCalled -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $VerifyUrlMultiPage1} 
    }
    It "Called page2" {
        Assert-MockCalled -CommandName Invoke-GraphRequest -ModuleName PSMSGraph -ParameterFilter {$Uri -eq $VerifyUrlMultiPage2} 
    }
}