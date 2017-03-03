# Get-AADUserByID

## SYNOPSIS
Retrieves an Azure AD User by their Object ID

## SYNTAX

```
Get-AADUserByID [-AccessToken] <Object> [-ObjectId] <String[]> [[-BaseUrl] <String>] [[-APIversion] <String>]
 [-WhatIf] [-Confirm]
```

## DESCRIPTION
Retrieves an Azure AD User by their Object ID

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$AADUser = Get-AADUserByID -AccessToken $GraphAccessToken -ObjectID d377e755-9365-400f-ab42-c0bf278c386e
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

### -ObjectId
The user's ObjectID e.g d377e755-9365-400f-ab42-c0bf278c386e

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

### MSGraphAPI.DirectoryObject.User

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByID](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserByID)

