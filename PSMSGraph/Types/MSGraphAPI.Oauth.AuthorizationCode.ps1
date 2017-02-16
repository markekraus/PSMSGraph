<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/8/2017 10:19 AM
     Eedited on:    2/16/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	MSGraphAPI.Oauth.AuthorizationCode.ps1
	===========================================================================
	.DESCRIPTION
		MSGraphAPI.Oauth.AuthorizationCode Type definition
#>

@{
    Name = 'MSGraphAPI.Oauth.AuthorizationCode'
    DefaultDisplayPropertySet = @(
        'AuthCodeBaseURL'
        'Success'
        'Issued'
        'IsExpired'
        'Expires'
        'NotBefore'
        'Application'
    )
    Properties = @(
        
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'Success'
            Value = {
                if ($This.AuthCodeCredential.UserName -eq 'NOAUTHCODE') { return $false }
                return $True
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'Expires'
            Value = {
                $This.Issued.AddMinutes(10)
            }
        }
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'IsExpired'
            Value = {
                $now = Get-date
                if ($now -gt $this.Expires) { return $true }
                return $false
            }
        }
        @{
            MemberType = 'ScriptMethod'
            MemberName = 'GetAuthCode'
            Value = {
                try {
                    $This.AuthCodeCredential.GetNetworkCredential().password
                }
                catch {
                    $null
                }                
            }
        }
    )
}