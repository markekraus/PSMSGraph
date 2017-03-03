# Update-GraphOauthAccessToken

## SYNOPSIS
Refreshes a Graph Oauth Access Token

## SYNTAX

```
Update-GraphOauthAccessToken [-AccessToken] <PSObject[]> [[-BaseUrl] <String>] [[-RenewalPeriod] <Int32>]
 [-Force] [-PassThru]
```

## DESCRIPTION
Requests a refresh of the Graph OAuth Access Token from Graph.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GraphToken = $GraphToken | Update-GraphOAuthAccessToken
```

## PARAMETERS

### -AccessToken
Graph OAUth Access Token Object created by Get-GraphOAuthAccessToken.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: Token

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -BaseUrl
Base Url for the OAuth Submission end point.
This is not required.
Defaults to 
    https://login.microsoftonline.com/common/oauth2/token

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: Https://login.microsoftonline.com/common/oauth2/token
Accept pipeline input: False
Accept wildcard characters: False
```

### -RenewalPeriod
The renewal period in seconds.
The default is 300 (5 minutes).
This is the number of seconds before the expiration date that a token will be refreshed.
This will prevent the access_token from being expired should the time between the token provider and the local system be offset.
If the token is already expired, this will be ignored.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
By default, a Token will not be renewed if it is not expired.
Using force will attempt a token refresh the token even if it is not expired.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands.
By default, this cmdlet does not generate any output.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### MSGraphAPI.Oauth.AccessToken

## NOTES
Ses Get-GraphOauthAccessToken for retrieving an OAuth Access Token from Graph

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken)

