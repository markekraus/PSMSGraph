<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 7:14 AM
     Last Modified: 3/01/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	PSMSGraph.psd1
	 -------------------------------------------------------------------------
	 Module Manifest
	-------------------------------------------------------------------------
	 Module Name: PSMSGraph
	===========================================================================
#>


@{
	
	# Script module or binary module file associated with this manifest
    RootModule = 'PSMSGraph.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.24.41'
	
	# ID used to uniquely identify this module
	GUID = '15978dcc-d5ad-4024-ab2a-28bdf946ece7'
	
	# Author of this module
	Author = 'Mark Kraus'
	
	# Company or vendor of this module
	CompanyName = 'Mitel'
	
	# Copyright statement for this module
	Copyright = '(c) 2017. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'Provides Connectivity and access to Microsoft Graph API'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '2.0'
	
	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '2.0.50727'
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @()
	
	# Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @(
        'System.Web'
        'System.Windows.Forms'
    )
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
    NestedModules = @('Public\Add-AADAppRoleAssignment.ps1','Public\Export-GraphApplication.ps1','Public\Export-GraphOauthAccessToken.ps1','Public\Get-AADGroupByDisplayName.ps1','Public\Get-AADGroupById.ps1','Public\Get-AADGroupMember.ps1','Public\Get-AADServicePrincipalAppRoleAssignedTo.ps1','Public\Get-AADServicePrinicpalbyDisplayName.ps1','Public\Get-AADServicePrinicpalbyId.ps1','Public\Get-AADUserAll.ps1','Public\Get-AADUserAppRoleAssignment.ps1','Public\Get-AADUserByID.ps1','Public\Get-AADUserByUserPrincipalName.ps1','Public\Get-GraphOauthAccessToken.ps1','Public\Get-GraphOauthAuthorizationCode.ps1','Public\Import-GraphApplication.ps1','Public\Import-GraphOauthAccessToken.ps1','Public\Invoke-GraphRequest.ps1','Public\New-GraphApplication.ps1','Public\New-GraphOauthAccessToken.ps1','Public\Remove-AADAppRoleAssignment.ps1','Public\Update-GraphOauthAccessToken.ps1')
	
	# Functions to export from this module
    FunctionsToExport = @('Add-AADAppRoleAssignment','Export-GraphApplication','Export-GraphOauthAccessToken','Get-AADGroupByDisplayName','Get-AADGroupByID','Get-AADGroupMember','Get-AADServicePrincipalAppRoleAssignedTo','Get-AADServicePrinicpalbyDisplayName','Get-AADServicePrinicpalbyId','Get-AADUserAll','Get-AADUserAppRoleAssignment','Get-AADUserByID','Get-AADUserByUserPrincipalName','Get-GraphOauthAccessToken','Get-GraphOauthAuthorizationCode','Import-GraphApplication','Import-GraphOauthAccessToken','Invoke-GraphRequest','New-GraphApplication','New-GraphOauthAccessToken','Remove-AADAppRoleAssignment','Update-GraphOauthAccessToken')
	
	# Cmdlets to export from this module
	CmdletsToExport = @()
	
	# Variables to export from this module
	VariablesToExport = @()
	
	# Aliases to export from this module
	AliasesToExport = @('Get-AADGroupMembers') 
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                'Graph'
                'GraphAPI'
                'MSGraph'
                'MSGraphAPI'
                'PSMSGraph'
                'PSMSGraphAPI'
                'MicrosoftGraph'
                'MicrosoftGraphAPI'
                'API'
                'OAuth'
                'REST'
                'CRUD'
            )
			
			# A URL to the license for this module.
            LicenseUri = 'https://github.com/markekraus/PSMSGraph/blob/master/LICENSE'
			
			# A URL to the main website for this project.
            ProjectUri = 'https://github.com/markekraus/PSMSGraph'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			ReleaseNotes = '# Version 1.0.24.41 (2017-04-15)
## Module Manifest
* Cleaned up white space at end of file

## Functions
### Import-GraphApplication
* Now provides its own error instead of Import-clixml

### Import-GraphOauthAccessToken
* Now provides its own error instead of Import-clixml

### Get-AADGroupMember
* Added ResultsPerPage Paramter to provide access to ''$top'' query filter.
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
* Created tests for Get-GraphOauthAccessToken'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}