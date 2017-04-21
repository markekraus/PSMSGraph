<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/21/2017 6:51 PM
     Edited on:     4/21/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	MSGraphAPI.Oauth.Exception.ps1
	===========================================================================
	.DESCRIPTION
		MSGraphAPI.Oauth.Exception Type Definition
#>

@{
    Name = 'MSGraphAPI.Oauth.Exception'
    Properties = @(
        @{
            MemberType = 'ScriptProperty'
            MemberName = 'JSONResonse'
            Value = {
                if($this.Response.ContentType -match 'application/json' ){
                    $Stream= $This.Response.GetResponseStream()
                    $StreamReader = New-Object System.IO.StreamReader $Stream
                    $Stream.Position = 0
                    $StreamReader.ReadToEnd() -replace '\\r\\n',"`r`n" | ConvertFrom-Json
                }
            }
        }
    )
}