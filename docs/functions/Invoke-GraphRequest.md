# Invoke-GraphRequest

## SYNOPSIS
Submits an access reqest to the Graph API

## SYNTAX

```
Invoke-GraphRequest [-AccessToken] <Object> [-Uri] <Uri> [[-Method] <WebRequestMethod>] [[-Body] <Object>]
 [[-Headers] <IDictionary>] [[-TimeoutSec] <Int32>] [[-ContentType] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
This is esentially an Invoke-ebRequest wrapper that handles the Access Token lifecycle and Authorization header.
This requires a valid Access Token in the form of a MSGraphAPI.Oauth.AccessToken and returns a MSGraphAPI.RequestResult Object

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-GraphRequest -AccessToken $value1 -Uri 'Value2' -Method $value3
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
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Uri
Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent.
Enter a URI.
This parameter supports HTTP, HTTPS, FTP, and FILE values.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
Specifies the method used for the web request.
The acceptable values for this parameter are:

- Default

- Delete

- Get

- Head

- Merge

- Options

- Patch

- Post

- Put

- Trace

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases: 
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 3
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Body
Specifies the body of the request.
The body is the content of the request that follows the headers.

The Body parameter can be used to specify a list of query parameters or specify the content of the response.

When the input is a GET request and the body is an IDictionary (typically, a hash table), the body is added to the URI as query parameters.
For other GET requests, the body is set as the value of the request body in the standard name=value format.

When the body is a form, or it is the output of an Invoke-GraphRequest call, Windows PowerShell sets the request content to the form fields.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Headers
Specifies the headers of the web request.
Enter a hash table or dictionary.

Any Authirzation header supplied here will be overwritten by what is provided in the Access Token.

To set UserAgent headers, use the UserAgent parameter.
You cannot use this parameter to specify UserAgent or cookie headers.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TimeoutSec
Specifies how long the request can be pending before it times out.
Enter a value in seconds.
The default value, 0, specifies an indefinite time-out.

A Domain Name System (DNS) query can take up to 15 seconds to return or time out.
If your request contains a host name that requires resolution, and you set TimeoutSec to a value greater than zero, but less than 15 seconds, it can take 15 seconds or more before a WebException is thrown, and your request times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ContentType
Specifies the content type of the web request.

The default value is 'application/json'

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: Application/json
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

### MSGraphAPI.RequestResult

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Invoke-GraphRequest](http://psmsgraph.readthedocs.io/en/latest/functions/Invoke-GraphRequest)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken](http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken)

[https://graph.microsoft.io/en-us/docs](https://graph.microsoft.io/en-us/docs)

[https://msdn.microsoft.com/en-us/library/azure/hh974476.aspx](https://msdn.microsoft.com/en-us/library/azure/hh974476.aspx)

