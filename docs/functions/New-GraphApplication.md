# New-GraphApplication

## SYNOPSIS
Creates a Graph Application object

## SYNTAX

```
New-GraphApplication [-Name] <String> [-ClientCredential] <PSCredential> [-RedirectUri] <String>
 [-Tenant] <String> [[-Description] <String>] [[-GUID] <Guid>]
```

## DESCRIPTION
Creates a Graph Application object containing data used by various cmdltes to define the parameters of the App registered on Azure AD.
This does not make any calls to Azure or the Gtaph API.
The Application will be inbeded in the Graph OAuthToken objects.
The MSGraphAPI.Application object contains the following properties:
Name             Name of the Application
Description      Description of the Application
UserAgent        The User-Agent header the Application will use to access the Graph API
ClientID         The Client ID of the Registered Azure App
RedirectUri      The Redirect URI of the Registered Azure App
ClientCredential A PS Crednetial containing the Client ID as the username and the Client Secret as the password
UserCredential   The Reddit Username and password of the developer account used for a Script application
GUID             A GUID to identitfy the application wihin this module (not consumed or used by Azure or Graph)

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

## PARAMETERS

### -Name
Name of the Graph App.
This does not need to match the name registered on Azure.
It is used for convenient identification and ducomentation purposes only.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AppName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ClientCredential
A PScredential object containging the Client ID as the Username and the Client Secret as the password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: ClientInfo

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RedirectUri
Redirect URI as registered on Azure for the App.
This must match exactly as entered in the App definition or authentication will fail.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tenant
The Azure/Office365 Tenant ID.
e.g.
adadtum.onmicrosft.com

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Description of the Graph App.
This is not required or used for anything.
It is provided for convenient identification and documentation purposes only.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GUID
A GUID to identify the application.
If one is not perovided, a new GUID will be generated.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: [system.guid]::NewGuid()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### MSGraphAPI.Application

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/New-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Export-GraphApplication)

[http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication](http://psmsgraph.readthedocs.io/en/latest/functions/Import-GraphApplication)

