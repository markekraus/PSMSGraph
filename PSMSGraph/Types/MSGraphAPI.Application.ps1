<#
    .NOTES
    ===========================================================================
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/8/2017 8:24 AM
     Edited on:     2/16/2017
     Created by:   	Mark Kraus
     Organization: 	Mitel
     Filename:     	MSGraphAPI.Application.ps1
    ===========================================================================
    .DESCRIPTION
        Contains type definition for MSGraphAPI.Application
#>

@{
    Name = 'MSGraphAPI.Application'
    DefaultDisplayPropertySet = @(
        'GUID'
        'Name'
        'Description'
        'RedirectUri'
        'ClientID'
    )
    Properties = @(
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'ToString'
            Value = {
                'Guid: {0} Name: {1}' -f $This.GUID, $This.Name
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'ClientID'
            Value = {
                $This.ClientCredential.UserName
            }
        }
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'GetClientSecret'
            Value = {
                try {
                    $This.ClientCredential.GetNetworkCredential().Password
                }
                catch {
                    $null
                }

            }
        }
    )
}