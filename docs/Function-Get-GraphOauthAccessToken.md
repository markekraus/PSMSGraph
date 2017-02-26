# Get-GraphOauthAccessToken

## SYNOPSIS
Retieves an OAuth Access Token from Microsoft

## SYNTAX

```
Get-GraphOauthAccessToken [-AuthenticationCode] <Object> [[-BaseURL] <String>] [[-Resource] <String>]
 [[-ResultVariable] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
A detailed description of the Get-GraphOauthAccessToken function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphAccessToken = Get-GraphOauthAccessToken -AuthenticationCode $GraphAuthCode
```

## PARAMETERS

### -AuthenticationCode
The Authentication Code returned from Get-GraphOauthAuthorizationCode

```yaml
Type: Object
Parameter Sets: (All)
Aliases: AuthCode

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -BaseURL
The Base URL used for retrieving OAuth Acces Tokens.
This is not required.
the default is

https://login.microsoftonline.com/common/oauth2/token

```yaml
Type: String
Parameter Sets: (All)
Aliases: URL

Required: False
Position: 2
Default value: Https://login.microsoftonline.com/common/oauth2/token
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Resource
The resource for which the OAuth Access token will be requested.
The default is

    https://graph.microsoft.com

You must set the resource to match the endpoints your token will be valid for.

    Microsft Graph:              https://outlook.office.com
    Azure AD Graph API:          https://graph.windows.net
    Office 365 Unified Mail API: https://outlook.office.com

If you need to access more than one resrouce, you will need to request multiple OAuth Access Tokens and use the correct tokens for the correct endpoints.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Https://graph.microsoft.com
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResultVariable
Name of a varibale to store the result from the Invoke-WebRequest.
This should be used for debugging only as it stores the access_token and refresh_tokens in memory as plain text.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
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
See Export-GraphOauthAccessToken for exporting Graph Acess Token Objects
See Import-GraphOauthAccessToken for importing exported Graph AcessToken Objects
See Update-GraphOauthAccessToken for refreshing the Graph Access Token

## RELATED LINKS

[Export-GraphOauthAccessToken
Import-GraphOauthAccessToken
Update-GraphOauthAccessToken]()

