# New-GraphOauthAccessToken

## SYNOPSIS
Creates an MSGraphAPI.Oauth.AccessToken Object

## SYNTAX

```
New-GraphOauthAccessToken [-Application] <Object> [-AccessTokenCredential] <PSCredential>
 [-RefreshTokenCredential] <PSCredential> [-RequestedDate] <DateTime> [-Response] <PSObject>
 [-ResponseHeaders] <PSObject> [-LastRequestDate] <DateTime> [[-Session] <WebRequestSession>] [[-GUID] <Guid>]
```

## DESCRIPTION
This creates a MSGraphAPI.Oauth.AccessToken object.
This only creates the objects used in this module.
It does not make any API calls.
To retrieve an OAuth Access Token, use Get-GraphOauthAccessToken

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-GraphOauthAccessToken -Application $GraphApp -AccessTokenCredential $AccessTokenCredential -RefreshTokenCredential $RefreshTokenCredential -RequestedDate (get-date) -Response $Response -ResponseHeaders $Result.Headers -LastRequestDate (get-date)
```

## PARAMETERS

### -Application
A MSGraphAPI.Application object.
See New-GraphApplication

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

### -AccessTokenCredential
A PSCredential Object containing the access_token as a password.
Username is ignored.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RefreshTokenCredential
A PSCredential Object containing the refresh_token as a password.
Username is ignored.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RequestedDate
The date and time the current access_token was requested

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Response
A PSObject containing the last response from the API converted from JSON and striped of the access_token and refresh_token

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResponseHeaders
A headers dictionary retruned from the API.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LastRequestDate
A datetime of the last API call made using thie token.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: True
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Session
The Session object used to access the API.
This creates a consistent experience accross API cals by mimicing a browser session.

```yaml
Type: WebRequestSession
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GUID
A GUID to identify the Graph OAuth Token Object.
If one is not provided, a new GUID will be generated.
This is used for internal reference only and is not consumed by the Graph API.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: 

Required: False
Position: 9
Default value: [Guid]::NewGuid()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### MSGraphAPI.Oauth.AccessToken

## NOTES
See Get-GraphOauthAccessToken

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphOauthAccessToken)

[http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Update-GraphOauthAccessToken)

