# Import-GraphApplication

## SYNOPSIS
Imports an exported Graph Application Object

## SYNTAX

### Path (Default)
```
Import-GraphApplication -Path <String[]> [-WhatIf] [-Confirm]
```

### LiteralPath
```
Import-GraphApplication -LiteralPath <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Imports an exported Graph Application Object and retruns a Graph Application Object.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphApp = Import-GraphApplication -Path 'c:\GraphApp.xml'
```

## PARAMETERS

### -Path
Specifies the XML files where the Graph Application Object was exported.

```yaml
Type: String[]
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -LiteralPath
Specifies the XML files where the Graph Application Object was exported.
Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed.
No characters are interpreted as wildcards.
If the path includes escape characters, enclose it in single quotation marks.
Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### MSGraphAPI.Application

## NOTES
See Export-GraphApplication for exporting Graph Application Objects
See New-GraphApplication for creating new Graph Application Objects

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication)

