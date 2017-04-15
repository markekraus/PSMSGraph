<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 8:32 AM
     Edited on:     3/30/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Import-GraphApplication.ps1
	===========================================================================
	.DESCRIPTION
		Import-GraphApplication Function
#>

<#
    .SYNOPSIS
        Imports an exported Graph Application Object
    
    .DESCRIPTION
        Imports an exported Graph Application Object and retruns a Graph Application Object.
    
    .PARAMETER Path
        Specifies the XML files where the Graph Application Object was exported.
    
    .PARAMETER LiteralPath
        Specifies the XML files where the Graph Application Object was exported. Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.
    
    .EXAMPLE
        PS C:\> $GraphApp = Import-GraphApplication -Path 'c:\GraphApp.xml'
    
    .NOTES
        See Export-GraphApplication for exporting Graph Application Objects
        See New-GraphApplication for creating new Graph Application Objects
    
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication

    .OUTPUTS
        MSGraphAPI.Application

#>
function Import-GraphApplication {
    [CmdletBinding(DefaultParameterSetName = 'Path',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication',
                   ConfirmImpact = 'Low',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.Application')]
    param
    (
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath
    )
    
    Process {
        Switch ($PsCmdlet.ParameterSetName) {
            'Path' {
                $ImportFiles = $Path
                $ImportParam = 'Path'
            }
            'LiteralPath' {
                $ImportFiles = $LiteralPath
                $ImportParam = 'LiteralPath'
            }
        }
        foreach ($ImportFile in $ImportFiles) {
            if ($pscmdlet.ShouldProcess($ImportFile)) {
                $Params = @{
                    "$ImportParam" = $ImportFile
                    ErrorAction = 'Stop'
                }
                try {
                    $InObject = Import-Clixml @Params
                }
                catch {
                    $ErrorMessage = "Unable to import from '{0}': {1}" -f @(
                        $ImportFile
                        $_.Exception.Message
                    )
                    Write-Error $ErrorMessage
                }
                $InObject | New-GraphApplication
            } #End Should Process
        } #End Foreach
    } #End Process
} #End Function