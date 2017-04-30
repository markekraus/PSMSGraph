# Version 1.0.26.43 (2017-04-30)
## Functions
### Get-AADGroupByDisplayName
* Fix error message to say Group instead of uuser and actually put the group name in the error
* ```Write-Error``` now includes original exception with error message

### Get-AADGroupById
* ```Write-Error``` now includes original exception with error message

## Tests
### Get-AADGroupByDisplayName.Unit.Tests.ps1
* Added missing code coverage for ```Invoke-GrapRequest``` error handling
* Now has 100% code coverage for ```Get-AADGroupByDisplayName```

### Get-AADGroupById.Unit.Tests.ps1
* Added missing code coverage for ```Invoke-GrapRequest``` error handling
* Now has 100% code coverage for ```Get-AADGroupById```

## Documentation
### Get-AADGroupByDisplayName
* Re-worded synopsis
* Add more helpful description
* Added clarity about the required reource for Access Tokens
* Fix typo in ```APIVersion``` parameter
* Corrected Output to reflect the correct object type
* Added the following links:
    + ```Get-GraphOauthAccessToken```
    + MSDN AAD Graph Group Operations
    + MSDN AAD Graph Filter parameter

### Get-AADGroupById
* Re-worded synopsis
* Add more helpful description
* Added clarity about the required reource for Access Tokens
* Added clarity on what ObjectID is required
* Fixed typo in ```APIVersion``` parameter
* Added the following links:
    + ```Get-GraphOauthAccessToken```
    + MSDN AAD Graph Group Operations
    + MSDN AAD Graph Filter parameter
