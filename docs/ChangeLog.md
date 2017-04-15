# Version 1.0.24.41 (2017-04-15)
## Module Manifest
* Cleaned up white space at end of file

## Functions
### Import-GraphApplication
* Now provides its own error instead of Import-clixml

### Import-GraphOauthAccessToken
* Now provides its own error instead of Import-clixml

### Get-AADGroupMember
* Added ResultsPerPage Paramter to provide access to '$top' query filter.
* Addeed .LINK to Get-AADGroupById
* Addeed .LINK to Get-AADGroupByDisplayName
* Added .INPUTS MSGraphAPI.DirectoryObject.Group
* Added .OUTPUTS MSGraphAPI.DirectoryObject.User

### Get-AADGroupById
* Addeed .LINK to Get-AADGroupByDisplayName
* Addeed .LINK to Get-AADGroupMember

### Get-AADGroupByDisplayName
* Addeed .LINK to Get-AADGroupMember
* Addeed .LINK to Get-AADGroupById

### Get-GraphOauthAccessToken
* **Breaking Change**: Removed ```ResultVariable``` and related debugging code that should never have been in production
* Removed ```ResultVariable``` parameter help
* Improved error reporting
* Fixed ```Resource``` parameter documentation
* Imrpoved Example
* Removed dangling ```&``` from ```$Body``` creation

## Build Tools
### psake.ps1
* Block ```staging``` branch recommits so clean pull requests can be made
* Add ```!skiprecommit``` commit tag to block recommits

## Tests
### Get-AADGroupMember.Unit.Tests.ps1
* Created tests for Get-AADGroupMember

### Import-GraphApplication.Unit.Tests.ps1
* Created tests for Import-GraphApplication

### Import-GraphOauthAccessToken.Unit.Tests.ps1
* Created tests for Import-GraphOauthAccessToken

### Get-AADGroupById.Unit.Tests.ps1
* Created tests for Get-AADGroupById

### Get-AADGroupByDisplayName.Unit.Tests.ps1
* Created tests for Get-AADGroupByDisplayName

### Get-GraphOauthAccessToken.Unit.Tests.ps1
* Created tests for Get-GraphOauthAccessToken



# Version 1.0.23.40 (2017-03-05)
## Functions

### All
* Added HelpUri and .LINK's to Comment based Help

### OAuth functions
* Standardized on "Oauth" in the function and file names (was a mix of "OAuth" and "Oath")

### Get-AADGroupMember
* Made function singular instead of plural (was Get-AADGroupMembers)
* Added Get-AADGroupMembers alias
* Fixed all the problems this rename caused and exposed with the build process and documentation

## Build Tools

### psake.ps1
* Restructured psake.ps1
	- Init > UnitTests > Build > Test > BuildDocs > Deploy > Post Deploy
* Added AST based Function and Alias module manifest population (now typos in file names will not cause function export issues)
* Added NestedModule Population
* Added Release notes and change log auto processing and documentation
* PostDeploy is now local build friendly

## Tests

### PSScriptAnalyzer.tests.Ps1
* Moved out of Project.Tests.ps1
* Re-wroded the tests so they display better in AppVeyor test logs
* Removed .psd1 from the tests because it dose not appear to support suppression and certain test will falsely fail due to the text in RealseNotes

### Project.Tests.ps1
* Moved the PSScriptAnalyzer tests to PSScriptAnalyzer.tests.Ps1
* Added Unit tag to "General project validation" so it test before and after build

### New-GraphApplication.Unit.Tests.ps1
* Added Unit test for New-GraphApplication

### New-GraphOauthAccessToken.Unit.Tests.ps1
* Added Unit test for New-GraphOauthAccessToken

## Project

### RELEASE.md
* Added this to server as the current release notes
* Integrates automatically with ChangeLog.md through build pipeline
* Gets copied to ```docs/```

### ChangeLog.md
* Added to ```docs/``` 
* Automatically managed by build process



