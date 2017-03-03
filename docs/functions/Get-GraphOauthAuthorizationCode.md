# Get-GraphOauthAuthorizationCode

## SYNOPSIS
Retrieves an OAuth Authorization code form Microsoft

## SYNTAX

```
Get-GraphOauthAuthorizationCode [-Application] <Object> [[-BaseURL] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Retrieves an OAuth Authorization code form Microsoft for a given Graph Application.
This commandlet requires an interactive session as you will need to provide your credentials and authorize the Graph Application.
The OAuth Authorization code will be used to obtain an OAuth Access Token.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphAuthCode = Get-GraphOauthAuthorizationCode -Application $GraphApp
```

## PARAMETERS

### -Application
MSGraphAPI.Application object (See New-GraphApplication)

```yaml
Type: Object
Parameter Sets: (All)
Aliases: App

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -BaseURL
The base URL for obtaining an OAuth Authorization Code form Microsoft.
This is provided in the event that a different URL is required.
The default is 

    https://login.microsoftonline.com/common/oauth2/authorize

```yaml
Type: String
Parameter Sets: (All)
Aliases: URL

Required: False
Position: 2
Default value: Https://login.microsoftonline.com/common/oauth2/authorize
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

### MSGraphAPI.Oauth.AuthorizationCode

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode)

[https://graph.microsoft.io/en-us/docs/authorization/auth_overview](https://graph.microsoft.io/en-us/docs/authorization/auth_overview)

[http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication)

