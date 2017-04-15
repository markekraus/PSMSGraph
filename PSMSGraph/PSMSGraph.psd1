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
	ModuleVersion = '1.0.23.40'
	
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
			ReleaseNotes = '# Version 1.0.23.40 (2017-03-05)
## Functions

### All
* Added HelpUri and .LINK''s to Comment based Help

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
* Automatically managed by build process'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}