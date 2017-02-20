<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 7:14 AM
     Eedited on:    2/16/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	PSMSGraph.psm1
	-------------------------------------------------------------------------
	 Module Name: PSMSGraph
	===========================================================================
#>

# Mark's "Poor Man's Classes"
# Pull in the type definitions from the Types folder
$TypesPath = Join-Path -Path $PSScriptRoot -ChildPath 'Types'
$TypesScripts = Get-ChildItem -Path $TypesPath -Filter '*.ps1'
$Types = foreach ($TypesScript in $TypesScripts) {
    Write-Verbose "Importing Type Data from '$($TypesScript.FullName)'"
    . $TypesScript.FullName
}
#Apply the type definitions
Foreach ($Type in $Types) {
    Write-Verbose "Adding $($Type.Name)"
    if ($Type.DefaultDisplayPropertySet) {
        Write-Verbose "-Adding Default Property Set"
        $Params = @{
            TypeName = $Type.Name
            DefaultDisplayPropertySet = $ObjectProperty.DefaultDisplayPropertySet
            ErrorAction = 'SilentlyContinue'
        }
        Update-TypeData @Params
    }
    foreach ($ObjectProperty in $Type.Properties) {
        Write-Verbose "-Adding $($ObjectProperty.MemberName) property"
        $Params = @{
            TypeName = $Type.Name
            MemberType = $ObjectProperty.MemberType
            MemberName = $ObjectProperty.MemberName
            Value = $ObjectProperty.Value
            ErrorAction = 'SilentlyContinue'
        }       
        Update-TypeData @Params
    }
}