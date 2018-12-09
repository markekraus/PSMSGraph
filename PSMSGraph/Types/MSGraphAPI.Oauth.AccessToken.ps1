<#
    .NOTES
    ===========================================================================
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/8/2017 2:05 PM
     Edited on:     2/16/2017
     Created by:   	Mark Kraus
     Organization: 	Mitel
     Filename:     	MSGraphAPI.Oauth.AccessToken.ps1
    ===========================================================================
    .DESCRIPTION
        MSGraphAPI.Oauth.AccessToken Type Definition
#>

@{
    Name = 'MSGraphAPI.Oauth.AccessToken'
    DefaultDisplayPropertySet = @(
        'GUID'
        'RequestedDate'
        'LastRequestDate'
        'IsExpired'
        'Expires'
        'NotBefore'
        'Scope'
        'Resource'
        'IsRefreshable'
        'Application'
    )
    Properties = @(
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'ToString'
            Value = {
                "Guid: {0} IsExpired '{1}'" -f $This.GUID, $This.IsExpired
            }
        }
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'GetAccessToken'
            Value = {
                try {
                    $This.AccessTokenCredential.GetNetworkCredential().password
                }
                catch {
                    $null
                }
            }
        }
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'GetRefreshToken'
            Value = {
                try {
                    $This.RefreshTokenCredential.GetNetworkCredential().password
                }
                catch {
                    $null
                }
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'TokenType'
            Value = {
                $this.Response.token_type
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'Expires'
            Value = {
                if ($This.Response.expires_on) {
                    (get-date '1970/01/01 -0').AddSeconds($This.Response.expires_on)
                }
                else {
                    [DateTime]::MinValue
                }
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'NotBefore'
            Value = {
                if ($This.Response.not_before) {
                    (get-date '1970/01/01 -0').AddSeconds($This.Response.not_before)
                }
                else {
                    [DateTime]::MaxValue
                }
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'IsExpired'
            Value = {
                $(get-date) -ge $this.Expires
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'Scope'
            Value = {
                $This.Response.Scope -split ' '
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'Resource'
            Value = {
                $This.Response.Resource
            }
        }
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'InvokeTokenRefresh'
            Value = {
                $This | Update-GraphOauthAccessToken
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'IsRefreshable'
            Value = {
                if ($This.GetRefreshToken() -eq 'NOREFRESH') { Return $False }
                Return $True
            }
        }
    )
}