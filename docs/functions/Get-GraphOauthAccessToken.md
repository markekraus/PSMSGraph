# Get-GraphOauthAccessToken

## SYNOPSIS
Retieves an OAuth Access Token from Microsoft

## SYNTAX

```
Get-GraphOauthAccessToken [-AuthenticationCode] <Object> [[-BaseURL] <String>] [[-Resource] <String>] [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
Takes an OAuth Acces Authorization code returned from Get-GraphOauthAuthorizationCode and
requests an OAuth Access Token for the provided resource from Microsoft.
A
MSGraphAPI.Oauth.AccessToken object is returned.
This object is required for making calls
to Invoke-GraphRequest and many other functions provided by this module.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$ClientCredential = Get-Credential
```

PS C:\\\> $Params = @{
Name = 'MyGraphApp'
Description = 'My Graph Application!'
ClientCredential = $ClientCredential
RedirectUri = 'https://adataum/ouath?'
UserAgent = 'Windows:PowerShell:GraphApplication'
}
PS C:\\\> $GraphApp = New-GraphApplication @Params
PS C:\\\> $GraphAuthCode = Get-GraphOauthAuthorizationCode -Application $GraphApp 
PS C:\\\> $GraphAccessToken = Get-GraphOauthAccessToken -AuthenticationCode $GraphAuthCode

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

    Microsft Graph:              https://graph.microsoft.com
    Azure AD Graph API:          https://graph.windows.net
    Office 365 Unified Mail API: https://outlook.office.com

If you need to access more than one resrouce, you will need to request multiple OAuth Access 
Tokens and use the correct tokens for the correct endpoints.

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
See Get-GraphOauthAuthorizationCode for obtaining a OAuth Authorization code.
See Export-GraphOauthAccessToken for exporting Graph Acess Token Objects
See Import-GraphOauthAccessToken for importing exported Graph AcessToken Objects
See Update-GraphOauthAccessToken for refreshing the Graph Access Token

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAuthorizationCode)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken)

[https://graph.microsoft.io/en-us/docs/authorization/auth_overview](https://graph.microsoft.io/en-us/docs/authorization/auth_overview)

