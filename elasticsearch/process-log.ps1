Param (
[Parameter (Mandatory=$false)]
[string]$logpath,

[Parameter (Mandatory=$false)]
[string]$jsonpath
)

$local=$([System.Net.Dns]::GetHostName());
$elastic_address="192.168.0.40:9200";

Function Cleardata() {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$line
    )
    
    $line=$line.Replace("`r`n","");
    $line=$line.Replace("`n","");
    $line=$line.Replace("`r","");
    $line=$line.Replace(";",""); 
    $line=$line.Replace(":","");
    $line=$line.Replace("\","");
    $line=$line.Replace("-","");
    $line=$line.Replace("``","");
    $line=$line.Replace("`"","");
    
    return $line;
}

try {
    $reader = [System.IO.File]::ReadAllText("C:\Projects\linux-dev\elk\elasticsearch\logs-examples\Monitel_Modes_Host-2021-10-27.log")

    $reader -split '(?m)(?=^\d{2}:\d{2}:\d{2})'| Where{$_} | ForEach-Object {
        $timestamp=$_.Substring(0,12).Replace(",",".");
        $module=$_.Substring($_.IndexOf('['),($_.IndexOf(']')-$_.IndexOf('[')+1));
        $message=$_.Substring($_.IndexOf(']')+5);
        $message_cleared= Cleardata $message;
        $severity=$_.Split(" ")[1];
        
        #Write-host "'node: '$($local)'";
        #Write-host "'timestamp: '$($timestamp)'";
        #Write-host "'module: '$($module)'";
        #Write-host "'severity: '$($severity)'";
        #Write-host "'message: '$($message_cleared)'";
        #Write-host "_____________________________________________";
        #Write-host "";
               
  }









}
catch {
    Write-host Get-ErrorInformation $_;
}

