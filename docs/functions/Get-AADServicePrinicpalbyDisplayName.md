# Get-AADServicePrinicpalbyDisplayName

## SYNOPSIS
Retrieves an Azure AD ServicePrincipal by the Display name

## SYNTAX

```
Get-AADServicePrinicpalbyDisplayName [-AccessToken] <Object> [-DisplayName] <String[]> [[-BaseUrl] <String>]
 [[-APIversion] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Retrieves an Azure AD ServicePrincipal by the Display Name

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$AADServicePrincipal = Get-AADServicePrincipalByDisplayName -AccessToken $GraphAccessToken -DisplayName 'Contoso Web App'
```

## PARAMETERS

### -AccessToken
MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisplayName
The ServicePrincipal's Display Name.
This must be an exact match and does not support wildcards

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -BaseUrl
The Azure AD Graph Base URL.
This is not required.
Deafult 
    https://graph.windows.net

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Https://graph.windows.net
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -APIversion
version og the API to use.
Default is 1.6

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 1.6
Accept pipeline input: True (ByPropertyName)
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

### MSGraphAPI.DirectoryObject.ServicePrincipal

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyDisplayName](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrinicpalbyDisplayName)

