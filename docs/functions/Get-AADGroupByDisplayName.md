# Get-AADGroupByDisplayName

## SYNOPSIS
Retrieves an Azure AD Group by the provided Display name

## SYNTAX

```
Get-AADGroupByDisplayName [-AccessToken] <Object> [-DisplayName] <String[]> [[-BaseUrl] <String>]
 [[-APIversion] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Searches Azure Active Directory Graph API for a Group by the provided display name. 
The provided displayname must be a full case-insensitive match.
Partial matches and
wildcards are not supported.
A MSGraphAPI.DirectoryObject.Group object will be
returned for the matching group.

Get-AADGroupByDisplayName requires a MSGraphAPI.Oauth.AccessToken issued for the 
https://graph.windows.net resource.
See the Get-GraphOauthAccessToken help for
more information.

Get-Help -Name Get-GraphOauthAccessToken -Parameter Resource

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$AADGroup = Get-AADGroupByDisplayName -AccessToken $GraphAccessToken -DisplayName 'Adataum Finance'
```

## PARAMETERS

### -AccessToken
MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
Access Token must be issued for the https://graph.windows.net resource.

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
The Group's Display Name.
This must be an exact case-insensitive match and does not 
support wildcards or partial matches.

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
Version of the API to use.
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

### MSGraphAPI.DirectoryObject.Group

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByDisplayName)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupMember)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADGroupByID)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

[https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/groups-operations](https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/groups-operations)

[https://msdn.microsoft.com/en-us/library/azure/ad/graph/howto/azure-ad-graph-api-supported-queries-filters-and-paging-options#filter](https://msdn.microsoft.com/en-us/library/azure/ad/graph/howto/azure-ad-graph-api-supported-queries-filters-and-paging-options#filter)

