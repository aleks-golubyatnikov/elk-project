param (
    [Parameter (Mandatory=$true)]
    [string]$Method,

    [Parameter (Mandatory=$true)]
    [string]$ContentType,
        
    [Parameter (Mandatory=$true)]
    [string]$Request
)

. .\service.ps1

$date=(Get-date).AddDays(-1) | Get-Date -UFormat "%Y-%m-%d";
$_date=(Get-date).AddDays(0) | Get-Date -UFormat "%Y-%m-%d";
$_log="$($_date)-logs-process.txt";

Function GetData () {
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
        $Response=$Response | ConvertTo-Json;
        
        SaveTextLog -_File "$($_log)" -_Data "$($Response)";         
    }
    catch {
        $formatstring = "{0} : {1}`n{2}`n" + "    + CategoryInfo          : {3}`n" + "    + FullyQualifiedErrorId : {4}`n";
        
        $fields = $_.InvocationInfo.MyCommand.Name, $_.ErrorDetails.Message, $_.InvocationInfo.PositionMessage, $_.CategoryInfo.ToString(),$_.FullyQualifiedErrorId;
        $e=$formatstring -f $fields;
        
        SaveTextLog -_File "$($_log)" -_Data "$($e)"; 
        Write-host "$($e)";
    }
    
    Return $Response;
}

switch ( $method ) {
    "GET" {
        GetData -_Method $Method -_ContentType $ContentType -_Request $Request;
    }
    
    "PUT" {
    
    }

    "POST" {
    
    }

    "DELETE" {
      
    }
}