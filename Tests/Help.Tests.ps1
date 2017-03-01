$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

Describe "Help tests for $moduleName" -Tags Build {

    $functions = Get-Command -Module $moduleName -CommandType Function
    $help = $functions | %{Get-Help $_.name}
    foreach($node in $help)
    {
        Context $node.name {

            it "has a description" {
                $node.description | Should Not BeNullOrEmpty
            }
            it "has an example" {
                 $node.examples | Should Not BeNullOrEmpty
            }
            foreach($parameter in $node.parameters.parameter)
            {
                if($parameter -notmatch 'whatif|confirm')
                {
                    it "parameter $($parameter.name) has a description" {
                        $parameter.Description.text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}