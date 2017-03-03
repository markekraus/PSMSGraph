# Remove-AADAppRoleAssignment

## SYNOPSIS
Removes an App Role Assignment

## SYNTAX

```
Remove-AADAppRoleAssignment [-AppRoleAssignment] <Object[]> [[-BaseUrl] <String>] [[-APIVersion] <String>]
 [-WhatIf] [-Confirm]
```

## DESCRIPTION
Removes an App Role Assignment.
This can be used to remove a users access to an Azure AD SaaS Application (Service Principal)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Results = $AADAppAssignments | Remove-AADAppRoleAssignment
```

## PARAMETERS

### -AppRoleAssignment
MSGraphAPI.DirectoryObject.AppRoleAssignment object

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
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
Position: 2
Default value: Https://graph.windows.net
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -APIVersion
version og the API to use.
Default is 1.6

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
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

### MSGraphAPI.RequestResult

## NOTES

## RELATED LINKS

[http://psmsgraph.readthedocs.io/en/latest/functions/Remove-AADAppRoleAssignment](http://psmsgraph.readthedocs.io/en/latest/functions/Remove-AADAppRoleAssignment)

[http://psmsgraph.readthedocs.io/en/latest/functions/Add-AADAppRoleAssignment](http://psmsgraph.readthedocs.io/en/latest/functions/Add-AADAppRoleAssignment)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADUserAppRoleAssignment)

[http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo](http://psmsgraph.readthedocs.io/en/latest/functions/Get-AADServicePrincipalAppRoleAssignedTo)

