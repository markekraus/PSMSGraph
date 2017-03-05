[![Build status](https://ci.appveyor.com/api/projects/status/3vamqyscyp0yddof/branch/master?svg=true)](https://ci.appveyor.com/project/markekraus/psmsgraph/branch/master)
[![Documentation Status](https://readthedocs.org/projects/psmsgraph/badge/?version=latest)](http://psmsgraph.readthedocs.io/en/latest/?badge=latest)

# PSMSGraph
This is a PowerShell module API wraper for the Microsoft Graph API. 

## What is Microsft Graph?

The [Microsoft Graph API](https://graph.microsoft.io/) is a REST API provided by Microsoft for integrating and managing Office 365 Exchange Online, OneDrive for Business, and Azure AD. It allows for application developers to integrate their apps with those Microsoft Services. Management of the environment is also possible but requires understanding of OAuth and REST.

## Why use the PSMSGraph module?

This module is an API wrapper. It seeks to take the "foreign" concepts of REST and OAuth and make them accessible and usable in PowerShell. This module strives to make PowerShell administration and automation tasks via the Microsoft Graph API more like other PowerShell commands.

### Features

* In-memory and at-rest security of the Access Token, Refresh Token, and Client Secret. These are all stored in memory as secure strings and are only made plain-text on demand when needed. When exported to disk, they are done so with CLI XML which maintains the secure string.
* Extensible type (Mark's "Poor Man's Classes") system allow for piping between functions similar to Active Directory or Exchange cmdlets
* Easy OAuth authorization process with a WinForms authentication popup
* No "mystery DLL's" required. The entire OAuth authorization, token request, and token refresh process is written in pure PowerShell
* Export and Import access tokens between sessions allowing you to authorize an application once and reuse the token until the refresh expires from lack of use or is revoked. Great for automation!
* No hassle Token Refreshing!! Calls to ```Invoke-GraphRequest``` (and all the functions that utalize it) automatically track the renewal needs for your Access Tokens and will automatically refresh them when needed.

## Installation
PSMSGraph is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/psmsgraph/). 

To Inspect:
```powershell
Save-Module -Name PSMSgraph -Path <path> 
```
To install:
```powershell
Install-Module -Name PSMSgraph 
```

## Documentaion

Documentation Site: [psmsgraph.readthedocs.io](https://psmsgraph.readthedocs.io/)

## Quickstart

### Create an Azure AD Application
 1. Go to [https://apps.dev.microsoft.com/](https://apps.dev.microsoft.com/)
 2. Register an app using your Office 365 or Azure AD account (the account must have permissions to add applications to you Azure AD)
 3. Generate a new password for your app
 4. Give the app the proper scope permissions
 5. Set an arbitrary Redirect URI (e.g. ```https://localhost/```)
 5. Note your Redirect URI, Application ID, and the password that was generated. The Application ID is your "Client ID" and the password is your "Client Secret". These are not your O365/Azure username and password. 

### Authorize the app and export your Access Token
```powershell
Import-Module -name 'PSMSGraph'
#In the credential prompt, provide your application's Client ID as the username and Client Secret as the password
$ClientCredential = Get-Credential
$GraphAppParams = @{
    Name = 'My Graph Application!'
    ClientCredential = $ClientCredential
    RedirectUri = 'https://localhost/'
    Tenant = 'adatum.onmicrosoft.com'

}
$GraphApp = New-GraphApplication @GraphAppParams
# This will prompt you to log in with your O365/Azure credentials. 
# This is required at least once to authorize the application to act on behalf of your account
# The username and password is not passed back to or stored by PowerShell.
$AuthCode = $GraphApp | Get-GraphOauthAuthorizationCode 
# see the following help for what resource to use. 
# get-help Get-GraphOauthAccessToken -Parameter Resource
$GraphAccessToken = $AuthCode | Get-GraphOauthAccessToken -Resource 'https://graph.windows.net'
$GraphAccessToken | Export-GraphOAuthAccessToken -Path 'c:\MyGraphApp\AccessToken.XML'
```

### Build a script to pull in all Azure AD users
```powershell
Import-Module -name 'PSMSGraph'
$GraphAccessToken =  Import-GraphOAuthAccessToken -Path 'c:\MyGraphApp\AccessToken.XML'
$GraphAccessToken | Update-GraphOAuthAccessToken -Force

$AADUsers = Get-AADUserAll -AccessToken $GraphAccessToken
$AADUsers | 
    Select-Object -Property * -ExcludeProperty _AccessToken | 
    Export-Csv -Path 'c:\MyGraphApp\AADUsers.csv' -NoTypeInformation

$GraphAccessToken  | Export-GraphOAuthAccessToken -Path 'c:\MyGraphApp\AccessToken.XML'
```

## Release Notes
[https://github.com/markekraus/PSMSGraph/blob/master/RELEASE.md](https://github.com/markekraus/PSMSGraph/blob/master/RELEASE.md)

## ChangeLog
[https://github.com/markekraus/PSMSGraph/blob/master/docs/ChangeLog.md](https://github.com/markekraus/PSMSGraph/blob/master/docs/ChangeLog.md)