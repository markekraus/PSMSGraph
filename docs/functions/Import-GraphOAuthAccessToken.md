# Import-GraphOauthAccessToken

## SYNOPSIS
Imports an exported Graph OAuth Access Token Object

## SYNTAX

### Path (Default)
```
Import-GraphOauthAccessToken -Path <String[]> [-WhatIf] [-Confirm]
```

### LiteralPath
```
Import-GraphOauthAccessToken -LiteralPath <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Imports an exported Graph OAuth Access Token Object and retruns a Graph  OAuth Access Token Object.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphAccessToken = Import-GraphOAuthAccessToken -Path 'c:\GraphAccessToken.xml'
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

### MSGraphAPI.Oauth.AccessToken

## NOTES
See Export-GraphOauthAccessToken for exporting Graph AcessToken Objects
See Get-GraphOauthAccessToken for obtaining a Graph Access Token from the API

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

