# Export-GraphApplication

## SYNOPSIS
Exports a Graph Application object to a file.

## SYNTAX

### Path (Default)
```
Export-GraphApplication -Path <String> [-Encoding <String>] -Application <PSObject> [-WhatIf] [-Confirm]
```

### LiteralPath
```
Export-GraphApplication -LiterlPath <String> [-Encoding <String>] -Application <PSObject> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Used to Export a Graph Application object to a file so it can later be imported.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphApp | Export-RedditApplication -Path 'c:\GraphApp.xml'
```

## PARAMETERS

### -Path
Specifies the path to the file where the XML representation of the Graph Application object will be stored

```yaml
Type: String
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LiterlPath
Specifies the path to the file where the XML representation of the Graph Application object will be stored.
Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed.
No characters are interpreted as wildcards.
If the path includes escape characters, enclose it in single quotation marks.
Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.

```yaml
Type: String
Parameter Sets: LiteralPath
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
Specifies the type of encoding for the target file.
The acceptable values for this parameter are:

-- ASCII
-- UTF8
-- UTF7
-- UTF32
-- Unicode
-- BigEndianUnicode
-- Default
-- OEM

The default value is Unicode.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Unicode
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Application
Graph Application Object to be exported.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: App, GraphApplication

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.IO.FileInfo, System.IO.FileInfo

## NOTES
This is an Export-Clixml wrapper.
See Import-GraphApplication for importing exported Graph Application Objects
See New-GraphApplication for creating new Graph Application objects

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication)

