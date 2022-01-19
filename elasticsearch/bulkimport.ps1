Param (
[Parameter (Mandatory=$true)]
[string]$logpath,

[Parameter (Mandatory=$true)]
[string]$jsonpath
)

$local=$([System.Net.Dns]::GetHostName());
$elastic_address="192.168.0.40:9200";

Function GetData () {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$req
    )
        
    try {
        $response=Invoke-RestMethod -Method GET -ContentType "application/json; charset=utf-8" -Uri "$($elastic_address+$req)" -ErrorAction Stop;        
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
    Return $response | ConvertTo-Json;
}

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

Function SaveToFile() {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$true)]
        [string]$data
    )
    try {
        $data | out-file -filepath $file -append
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
}

Function LoadData() {
 Param (
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$false)]
        [string]$req,

        [Parameter(Mandatory=$false)]
        [string]$index

    )
    $data="";
    
    #Use template depend of logs schema
    (Get-Content $file -Raw) -split '(?m)(?=^\d{2}:\d{2}:\d{2})'| Where{$_} | ForEach-Object {
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
               
        if(![string]::IsNullOrEmpty($message_cleared.Trim()) -AND ![string]::IsNullOrEmpty($module.Trim()) -AND ![string]::IsNullOrEmpty($timestamp.Trim())){
            $data+="{`"index`": {`"_index`": `"$index`"}}`r`n";
            $data+="{`"timestamp`": `"$((Get-Date).ToString("yyyy-MM-dd"))T$timestamp`",`"node`": `"$local`", `"severity`": `"$severity`", `"module`": `"$module`", `"message`": `"$message_cleared`"}`r`n";
        }
  }
    
    try {
        SaveToFile ".\data.json" $data; 
        $response=Invoke-RestMethod -Method POST -ContentType "application/json; charset=utf-8" -Uri "$($elastic_address+$req)" -Body $data;
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
    
    $response=$response | ConvertTo-Json;
    SaveToFile ".\responce.json" $response;
    
    Return $response;
}

#Get indexes status
#Write-host $(GetData "/_cat/indices?pretty&format=json") ;

#Get index mappings (log-modes)
#Write-host $(GetData "/logs-modes/_mappings?pretty&format=json");

#Import data
LoadData ".\Monitel_Modes_Host-2021-10-27.log" "/logs-modes/_bulk?pretty&format=json" "logs-modes";