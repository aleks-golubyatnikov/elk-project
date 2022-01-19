param (
    [Parameter (Mandatory=$true)]
    [string]$Method,

    [Parameter (Mandatory=$true)]
    [string]$ContentType,
        
    [Parameter (Mandatory=$true)]
    [string]$Request,

    [Parameter (Mandatory=$false)]
    [string]$FilePath
)

Function GetData () {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_Method,

        [Parameter(Mandatory=$true)]
        [string]$_ContentType,

        [Parameter(Mandatory=$true)]
        [string]$_Request
    )
        
    try {
        $Response=Invoke-RestMethod -Method $_Method -ContentType "$_ContentType" -Uri "$_Request" -ErrorAction Stop;        
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
    Return $Response | ConvertTo-Json;
}

Function BulkImport() {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_Method,

        [Parameter(Mandatory=$true)]
        [string]$_ContentType,

        [Parameter(Mandatory=$true)]
        [string]$_Request,

        [Parameter(Mandatory=$true)]
        [string]$_FilePath

    )

    try {
        $_data = @{
            filename = $_FilePath
            file = Get-Item -Path $_FilePath
            content_type = 'application/json'
        }
        
        Write-host $_FilePath | ConvertTo-Json;
        #$Response=Invoke-RestMethod -Method $_Method -ContentType $_ContentType -Uri "$_Request" -Body $_data;
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
    Return $Response | ConvertTo-Json;
}


switch ( $method ) {
    "GET" {
        GetData -_Method $Method -_ContentType $ContentType -_Request $Request;
    }
    
    "PUT" {
    
    }

    "POST" {
        BulkImport -_Method $Method -_ContentType $ContentType -_Request $Request -_FilePath $FilePath;
    }

    "DELETE" {
      
    }
}



