## Functions
### Get-GraphOauthAccessToken
* Revised Invoke-WebRequest error handling. Now uses MSGraphAPI.Oauth.Exception to handle formating
* Simplified error handling for JSON parsing

## Types
### MSGraphAPI.Oauth.Exception
* Added the MSGraphAPI.Oauth.Exception type to handle OAuth related Invoke-Webrequest Exceptions
* New ScriptMethod JSONResponse converts the response stream from the Invoke-WebRequest exception from JSON to PSObject

## Test
### Get-GraphOauthAccessToken.Unit.Tests.ps1
* Added missing code coverage for Invoke-webRequest error handling
* Add missing code coverage for JSON parsing error handling
* Now at 100% code coverage for Get-GraphOauthAccessToken

## Built Toolds
### psake.ps1
* Adjust recommit logic in PostDeploy task
* Added ```!forcrecommit``` to override default ignores if needed
* Added ```devlop``` to ignored branch for recommits as constant work in the develop branch leads to staging issues.