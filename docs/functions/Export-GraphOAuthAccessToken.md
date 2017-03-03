# Export-GraphOauthAccessToken

## SYNOPSIS
Exports a Graph OAuth Access Token object to a file.

## SYNTAX

### Path (Default)
```
Export-GraphOauthAccessToken -Path <String> [-Encoding <String>] -AccessToken <PSObject> [-WhatIf] [-Confirm]
```

### LiteralPath
```
Export-GraphOauthAccessToken -LiterlPath <String> [-Encoding <String>] -AccessToken <PSObject> [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
Used to Export a Graph OAuth Access Token object to a file so it can later be imported.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphAccessToken | Export-GraphOAuthAccessToken -Path 'c:\GraphAccessToken.xml'
```

## PARAMETERS

### -Path
Specifies the path to the file where the XML representation of the Graph AccessToken object will be stored

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
Specifies the path to the file where the XML representation of the Graph AccessToken object will be stored.
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

### -AccessToken
Graph OAuth Acess Token Object to be exported.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: Token

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
See Import-GraphOauthAccessToken for importing exported Graph AccessToken Objects
See Get-GraphOauthAccessToken for obtaining a Graph AccessToken Objects

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

