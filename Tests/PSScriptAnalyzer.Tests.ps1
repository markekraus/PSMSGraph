<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/28/2017 11:49 AM
     Editied on:    3/4/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	PSScriptAnalyzer.tests.Ps1
	===========================================================================
	.DESCRIPTION
		Runs PSScriptAnalyzer tests for every rule against every file in the module
#>
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "PSScriptAnalyzer Tests" -Tags Build {
    
    $Rules = Get-ScriptAnalyzerRule
    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1 -Recurse | Where-Object fullname -notmatch 'classes'
    
    foreach ($Script in $scripts) {
        $RelPath = $Script.FullName.Replace($moduleRoot, '') -replace '^\\', ''
        Context "$RelPath" {            
            foreach ($rule in $rules) {
                It "Passes $rule" {
                    
                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName).Count | Should Be 0
                }
            }
        }
    }
}