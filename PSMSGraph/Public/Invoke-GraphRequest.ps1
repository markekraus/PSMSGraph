<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
	 Created on:   	2/13/2017 6:14 AM
     Edited on:     2/16/2017
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Invoke-GraphRequest.ps1
	===========================================================================
	.DESCRIPTION
		Invoke-GraphRequest Function
#>

<#
    .SYNOPSIS
        Submits an access reqest to the Graph API
    
    .DESCRIPTION
        This is esentially an Invoke-ebRequest wrapper that handles the Access Token lifecycle and Authorization header. This requires a valid Access Token in the form of a MSGraphAPI.Oauth.AccessToken and returns a MSGraphAPI.RequestResult Object
    
    .PARAMETER AccessToken
        MSGraphAPI.Oauth.AccessToken object obtained from Get-GraphOauthAccessToken.
    
    .PARAMETER Uri
        Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent. Enter a URI. This parameter supports HTTP, HTTPS, FTP, and FILE values.
    
    .PARAMETER Method
        Specifies the method used for the web request. The acceptable values for this parameter are:
        
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
    
    .PARAMETER Body
        Specifies the body of the request. The body is the content of the request that follows the headers.
        
        The Body parameter can be used to specify a list of query parameters or specify the content of the response.
        
        When the input is a GET request and the body is an IDictionary (typically, a hash table), the body is added to the URI as query parameters. For other GET requests, the body is set as the value of the request body in the standard name=value format.
        
        When the body is a form, or it is the output of an Invoke-GraphRequest call, Windows PowerShell sets the request content to the form fields.
    
    .PARAMETER Headers
        Specifies the headers of the web request. Enter a hash table or dictionary.
        
        Any Authirzation header supplied here will be overwritten by what is provided in the Access Token.
        
        To set UserAgent headers, use the UserAgent parameter. You cannot use this parameter to specify UserAgent or cookie headers.
    
    .PARAMETER TimeoutSec
        Specifies how long the request can be pending before it times out. Enter a value in seconds. The default value, 0, specifies an indefinite time-out.
        
        A Domain Name System (DNS) query can take up to 15 seconds to return or time out. If your request contains a host name that requires resolution, and you set TimeoutSec to a value greater than zero, but less than 15 seconds, it can take 15 seconds or more before a WebException is thrown, and your request times out.
    
    .PARAMETER ContentType
        Specifies the content type of the web request.
        
        The default value is 'application/json'
    
    .EXAMPLE
        PS C:\> Invoke-GraphRequest -AccessToken $value1 -Uri 'Value2' -Method $value3
    
    .OUTPUTS
        MSGraphAPI.RequestResult

    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Invoke-GraphRequest
    .LINK
        http://psmsgraph.readthedocs.io/en/latest/functions/Get-GraphOauthAccessToken
    .LINK 
        https://graph.microsoft.io/en-us/docs
    .LINK
        https://msdn.microsoft.com/en-us/library/azure/hh974476.aspx
#>
function Invoke-GraphRequest {
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://psmsgraph.readthedocs.io/en/latest/functions/Invoke-GraphRequest',
                   SupportsShouldProcess = $true)]
    [OutputType('MSGraphAPI.RequestResult')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('MSGraphAPI.Oauth.AccessToken')]$AccessToken,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]$Uri,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'Default',
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Object]$Body,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0,2147483647)]
        [System.Int32]$TimeoutSec,
        
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [System.String]$ContentType = 'application/json'
    )
    
    Process {
        Try {
            Write-Verbose "Performing token refresh"
            $AccessToken | Update-GraphOauthAccessToken -ErrorAction Stop
        }
        Catch {
            $ErrorMessage = "Unable to refresh Access Token '{0}': {1}" -f $AccessToken.GUID, $_.Exception.Message
            Write-Error $ErrorMessage
            return
        }
        if (-not $pscmdlet.ShouldProcess("$Uri")) {
            Return
        }
        Write-Verbose "Set base parameters"
        $Params = @{
            ContentType = $ContentType
            Uri = $Uri
            WebSession = $AccessToken.Session
            Method = $Method
            ErrorAction = 'Stop'
        }
        if ($Body) {
            Write-Verbose "Setting Body Parameter"
            $Params['Body'] = $Body
        }
        if ($TimeoutSec) {
            Write-Verbose "Setting TimeoutSec Parameter"
            $Params['TimeoutSec'] = $TimeoutSec
        }
        Write-Verbose "Setting Headers Parameter"
        $Params['Headers'] = @{ }
        if ($Headers) {
            Write-Verbose "Setting user supplied headers"
            $Params['Headers'] = $Headers
        }
        Write-Verbose "Setting Authorization header"
        $Params['Headers']['Authorization'] = 'Bearer {0}' -f $AccessToken.GetAccessToken()
        $RequestedDate = Get-Date
        try {
            $Result = Invoke-WebRequest @Params
            $ReceivedDate = Get-Date
        }
        catch {
            $response = $_.Exception.Response
            $Stream = $response.GetResponseStream()
            $Stream.Position = 0
            $StreamReader = New-Object System.IO.StreamReader $Stream
            $ResponseBody = $StreamReader.ReadToEnd()
            $ErrorMessage = "Unable to query Uri '{0}': {1}: {2}" -f $Uri, $_.Exception.Message, $ResponseBody
            Set-Variable -Scope global -Name _invokeGraphRequestException -Value $_
            Write-Error -message $ErrorMessage -Exception $_.Exception
            return
        }
        Write-Verbose "Truncating Authorization header"
        try {
            $Params['Headers']['Authorization'] = '{0}...{1}<truncated>' -f $Params.Headers.Authorization.Substring(0, 25),
            $Params.Headers.Authorization.Substring(($Params.Headers.Authorization.Length - 11), 10)
        }
        catch {
            Write-Verbose "No Authorization header to truncate"
        }        
        switch ($Result.Headers.'Content-Type') {
            { $_ -match 'application/json' } {
                Write-Verbose "Converting result from JSON to PSObject"
                $ConentObject = $Result.Content | ConvertFrom-Json -ErrorAction SilentlyContinue
                break
            }
            { $_ -match 'application/xml' } {
                Write-Verbose "Converting result from XML to PSObject"
                [xml]$ConentObject = $Result.Content
                break
            }
            default {
                Write-Verbose "Unhandled Content-Type. ContentObject will be raw."
                $ConentObject = $Result.Content
            }
        }        
        Write-Verbose "Setting LastRequestDate on Access Token"
        $AccessToken.LastRequestDate = $RequestedDate
        [pscustomobject]@{
            PSTypeName = 'MSGraphAPI.RequestResult'
            Result = $Result
            Uri = $Uri
            Headers = $Params.Headers
            InvokeWebRequestParameters = $Params
            ContentType = $ContentType
            TimeoutSec = $TimeoutSec
            Body = $Body
            RequestedDate = $RequestedDate
            RecievedDate = $ReceivedDate
            AccessToken = $AccessToken
            ContentObject = $ConentObject
        }
    }
    
}
