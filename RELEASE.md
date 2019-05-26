# Version 1.0.26.43 (2017-04-30)

## Functions

### Add-AADAppRoleAssignment

* Whitespace fixes #32

### Export-GraphApplication

* Whitespace fixes #32
* Renamed `LiterlPath` parameter to `LiteralPath` (non-breaking) #32
* Verbose message spelling fix #32

### Export-GraphOauthAccessTokenFunction

* Whitespace fixes #32

### Get-AADGroupByDisplayName

* Whitespace fixes #32

### Get-AADGroupById

* Whitespace fixes #32

### Get-AADGroupMember

* Whitespace fixes #32

### Get-AADServicePrincipalAppRoleAssignedTo

* Whitespace fixes #32

### Get-AADServicePrinicpalbyDisplayName

* Whitespace fixes #32

### Get-AADServicePrinicpalbyId

* Whitespace fixes #32

### Get-AADUserAll

* Whitespace fixes #32

### Get-AADUserAppRoleAssignment

* Whitespace fixes #32

### Get-AADUserByID

* Whitespace fixes #32

### Get-AADUserByUserPrincipalName

* Whitespace fixes #32

### Get-GraphOauthAccessToken

* Whitespace fixes #32

### Get-GraphOauthAuthorizationCode

* Whitespace fixes #32
* Added a `ForcePrompt` parameter to allow for forcing certain prompts in the authorization process. #34 (Thanks @markdomansky!)

### Import-GraphApplication

* Whitespace fixes #32

### Import-GraphOauthAccessToken

* Whitespace fixes #32

### Invoke-GraphRequest

* Whitespace fixes #32

### New-GraphApplication

* Whitespace fixes #32

### New-GraphOauthAccessToken

* Whitespace fixes #32

### Remove-AADAppRoleAssignment

* Whitespace fixes #32

### Update-GraphOauthAccessToken

* Whitespace fixes #32

## Types

### MSGraphAPI.Application

* Whitespace fixes #32

### MSGraphAPI.Oauth.AccessToken

* Whitespace fixes #32
* Added `ExpiresUTC` and `NotBeforeUTC` properties #27
* `Expires` and `IsExpired` now calculates from UTC unix epoch instead of local time. #27

### MSGraphAPI.Oauth.AuthorizationCode

* Whitespace fixes #32

### MSGraphAPI.Oauth.Exception

* Whitespace fixes #32