<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/13/2017 04:25 AM
     Edited on:     4/22/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	Get-GraphOauthAccessToken.Unit.Tests.ps1
	===========================================================================
	.DESCRIPTION
		Unit Tests for Get-GraphOauthAccessToken
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Get-GraphOauthAccessToken'

$TypeName = 'MSGraphAPI.Oauth.AccessToken'

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

$AuthCodeSecret = '67890'
$SecAuthCodeSecret = $AuthCodeSecret | ConvertTo-SecureString -AsPlainText -Force
$AuthCodeCredential = [system.Management.Automation.PSCredential]::new('AuthCode', $SecAuthCodeSecret)
$AuthCode = [pscustomobject]@{
    PSTypeName = 'MSGraphAPI.Oauth.AuthorizationCode'
    AuthCodeCredential = $AuthCodeCredential
    ResultURL = 'https://loclahost'
    Application = $App
    AuthCodeBaseURL = 'https://login.microsoftonline.com/common/oauth2/authorize'
    Issued = Get-date
}
$BadAuthCodeSecret = '09876'
$SecBadAuthCodeSecret = $BadAuthCodeSecret | ConvertTo-SecureString -AsPlainText -Force
$BadAuthCodeCredential = [system.Management.Automation.PSCredential]::new('AuthCode', $SecBadAuthCodeSecret)
$BadAuthCode = [pscustomobject]@{
    PSTypeName = 'MSGraphAPI.Oauth.AuthorizationCode'
    AuthCodeCredential = $BadAuthCodeCredential
    ResultURL = 'https://loclahost2'
    Application = $App
    AuthCodeBaseURL = 'https://login.microsoftonline.com/common/oauth2/authorize'
    Issued = Get-date
}
$BadJSONAuthCodeSecret = '54321'
$SecBadJSONAuthCodeSecret = $BadJSONAuthCodeSecret | ConvertTo-SecureString -AsPlainText -Force
$BadJSONAuthCodeCredential = [system.Management.Automation.PSCredential]::new('AuthCode', $SecBadJSONAuthCodeSecret)
$BadJSONAuthCode = [pscustomobject]@{
    PSTypeName = 'MSGraphAPI.Oauth.AuthorizationCode'
    AuthCodeCredential = $BadJSONAuthCodeCredential
    ResultURL = 'https://loclahost2'
    Application = $App
    AuthCodeBaseURL = 'https://login.microsoftonline.com/common/oauth2/authorize'
    Issued = Get-date
}

$Params = @{
    AuthenticationCode = $AuthCode
}

$RequiredParams = @(
    'AuthenticationCode'
)
$VerifyBody = @(
     'grant_type=authorization_code'
     '&redirect_uri=https%3a%2f%2flocalhost'
     '&client_id=12345'
     '&code=67890'
     '&resource=https%3a%2f%2fgraph.microsoft.com' 
     '&client_secret=54321'
) -Join ''
$VerifyBadBody = @(
     'grant_type=authorization_code'
     '&redirect_uri=https%3a%2f%2flocalhost'
     '&client_id=12345'
     '&code=09876'
     '&resource=https%3a%2f%2fgraph.microsoft.com' 
     '&client_secret=54321'
) -Join ''
$VerifyBadJSONBody = @(
     'grant_type=authorization_code'
     '&redirect_uri=https%3a%2f%2flocalhost'
     '&client_id=12345'
     '&code=54321'
     '&resource=https%3a%2f%2fgraph.microsoft.com' 
     '&client_secret=54321'
) -Join ''
$ValidBodies = @(
    $VerifyBody
    $VerifyBadBody
    $VerifyBadJSONBody
)

$JWT = @( 
    'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJhdWQiOiJlMmFkOTE4ZS1kYzg3L'
    'TRjMjMtODAzYy1lNjdlNDNlMGYyMTciLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3'
    'dzLm5ldC84ZjUyYmM4YS1jNDZmLTRlYzQtYjM4MC1hZjdlYTQ0YWE5OTcvIiwiaWF'
    '0IjoxNDkyMTY0Mjg1LCJuYmYiOjE0OTIxNjQyODUsImV4cCI6MTQ5MjE2ODE4NSwi'
    'YW1yIjpbInB3ZCJdLCJmYW1pbHlfbmFtZSI6IlRlc3RlcnRvbiIsImdpdmVuX25hb'
    'WUiOiJCb2IiLCJpcGFkZHIiOiI4LjguOC44IiwibmFtZSI6IkJvYiBUZXN0ZXJ0b2'
    '4iLCJvaWQiOiJjZDI4NzY0Ny0yNmVjLTRhZmEtYTJkMy01NDBlOTRmN2VlOWQiLCJ'
    'vbnByZW1fc2lkIjoiUy0xLTUtMjEtMTAwNDMzNjM0OC0xMTc3MjM4OTE1LTY4MjAw'
    'MzMzMC00MDE0OSIsInBsYXRmIjoiMyIsInN1YiI6ImxLUF9NRi1JNTIxTHpzd0QtO'
    'VJiRXhnZWlIM3RIeUtIaHBMQ3BJWkdEUTUiLCJ0aWQiOiI4ZjUyYmM4YS1jNDZmLT'
    'RlYzQtYjM4MC1hZjdlYTQ0YWE5OTciLCJ1bmlxdWVfbmFtZSI6Im1ncl9rcmF1c21'
    'AbWl0ZWwuY29tIiwidXBuIjoibWdyX2tyYXVzbUBtaXRlbC5jb20iLCJ1dGkiOiJB'
    'X09YLURidnZGeXdrM1pSZERzQlpaIiwidmVyIjoiMS4wIn0.'
) -join ''
$Scopes = @(
    "Calendars.Read Calendars.Read.Shared Contacts.Read Contacts.Read.Shared" 
    "Directory.Read.All Files.Read Files.Read.All Files.Read.Selected" 
    "Group.Read.All IdentityRiskEvent.Read.All Mail.Read Mail.Read.Shared" 
    "Notes.Read Notes.Read.All People.Read Sites.Read.All Tasks.Read"
    "User.Read User.Read.All User.ReadBasic.All"
) -Join ' '
$Global:JSONResponse = @"
{
    "token_type":  "Bearer",
    "scope":  "$Scopes",
    "expires_in":  "3599",
    "ext_expires_in":  "0",
    "expires_on":  "1492168185",
    "not_before":  "1492164285",
    "resource":  "https://graph.microsoft.com",
    "access_token":  "794abc9c-40f6-4f89-8dc4-60304e6ad46c",
    "refresh_token":  "69284247-9d31-4bb7-b48b-f23f7394e0ba",
    "id_token":  "$JWT"
}
"@

$Global:ResponseHeaders = @{
    'Pragma'                    = 'no-cache'
    'Strict-Transport-Security' = 'max-age=31536000; includeSubDomains'
    'X-Content-Type-Options'    = 'nosniff'
    'x-ms-request-id'           = '8046f2e1-18a8-4237-9515-b9db164f68a9'
    'Cache-Control'             = 'no-cache, no-store'
    'Content-Type'              = 'application/json; charset=utf-8'
    'Expires'                   = '-1'
    'P3P'                       = 'CP="DSP CUR OTPi IND OTRi ONL FIN"'
    'Set-Cookie'                = @('esctx=AQABAAAAAABnfiG;' 
                                    'domain=.login.microsoftonline.com;'
                                    'path=/;'
                                    'secure;' 
                                    'HttpOnly,x-ms-gateway-slice=006;' 
                                    'path=/;' 
                                    'secure;' 
                                    'HttpOnly,stsservicecookie=ests;' 
                                    'path=/;' 
                                    'secure;' 
                                    'HttpOnly') -Join ' '
    'Server'                    = 'Microsoft-IIS/8.5'
    'X-Powered-By'              = 'ASP.NET'
    'Date'                      = Get-Date  
    'Content-Length'            = $Global:JSONResponse.Length
}

Describe $Command -Tags Unit {
    # Mock to send error when the Uri sent to Invoke-GraphRequest
    Mock -CommandName Invoke-WebRequest -ModuleName PSMSGraph -ParameterFilter {$ValidBodies -notcontains $Body} -MockWith {
       Throw "$Body not in `r`n$($ValidBodies -join "`r`n ")"
    }
    Mock -CommandName Invoke-WebRequest -ModuleName PSMSGraph -ParameterFilter {$Body -eq $ValidBodies[0]} -MockWith {
        $MockResponse = [pscustomobject]@{
            Content = $Global:JSONResponse
            Headers = $Global:ResponseHeaders 
        }
        return $MockResponse
    }
    Mock -CommandName Invoke-WebRequest -ModuleName PSMSGraph -ParameterFilter {$Body -eq $ValidBodies[1]} -MockWith {
        $Params = {
            Uri = $Uri
            Method = $Method
            ErrorAction = 'Stop'
            Body = $bode
            ContentType = $ContentType
            Session = $Session
            UseBasicParsing = $true
        }
        Microsoft.PowerShell.Utility\Invoke-WebRequest @Params
    }
    Mock -CommandName Invoke-WebRequest -ModuleName PSMSGraph -ParameterFilter {$Body -eq $ValidBodies[2]} -MockWith {
        $MockResponse = [pscustomobject]@{
            Content = 'This is bad JSON'
            Headers = $Global:ResponseHeaders 
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
    It "Throws a MSGraphAPI.Oauth.Exception exception on Invoke-WebRequest erros." {
        $LocalParams = $Params.psobject.Copy()
        $LocalParams.AuthenticationCode = $BadAuthCode
        Try{
            & $Command @LocalParams -ErrorAction Stop 
        }
        Catch{
            $Exception = $_
        } 
        $Exception.Exception.psobject.typenames -contains 'MSGraphAPI.Oauth.Exception' | should be $true        
    }
    It "Throws an exception on JSON parse erros." {
        $LocalParams = $Params.psobject.Copy()
        $LocalParams.AuthenticationCode = $BadJSONAuthCode
        { & $Command @LocalParams -ErrorAction Stop } | should throw 'Invalid JSON'
    }    
}
Remove-Variable -Scope Global -Name ResponseHeaders
Remove-Variable -Scope Global -Name JSONResponse
