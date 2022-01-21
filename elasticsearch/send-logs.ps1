param (
    [Parameter (Mandatory=$true)]
    [string]$ElasticAddress,

    [Parameter (Mandatory=$true)]
    [string]$FilesPath

)

. .\service.ps1

$_date=(Get-date).AddDays(0) | Get-Date -UFormat "%Y-%m-%d";
$_log="$($_date)-logs-process.txt";

Function SendData() {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_ElasticAddress,

        [Parameter(Mandatory=$true)]
        [string]$_FilesPath
    )

    $result="true";
        
    try {
        # -XPOST
        # -H "Content-Type: application/json"
        # "http://192.168.0.40:9200/logs-modes/_bulk?pretty"
        # --data-binary @"C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed\Monitel_Modes_Host-2022-01-20-data-0.json"  
        
        #$curl = New-Object System.Diagnostics.ProcessStartInfo;
        ##$curl.FileName = "curl.exe";
        #$curl.Arguments="-XPOST -H ""Content-Type: application/json"" ""http://192.168.0.40:9200/logs-modes/_bulk?pretty"" --data-binary @""C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed\Monitel_Modes_Host-2022-01-20-data-0.json"" ";
        #$curl.Arguments="-XGET ""http://192.168.0.40:9200/_cat/indices?pretty&format=json"" ";
        
        $pinfo = New-Object System.Diagnostics.ProcessStartInfo
        $pinfo.FileName = "curl.exe"
        #$pinfo.Arguments = "google.com", "8.8.8.8"
        #$pinfo.Arguments="-XGET ""http://192.168.0.40:9200/_cat/indices?pretty&format=json"" ";
        $pinfo.Arguments="-XPOST -H ""Content-Type: application/json"" ""http://192.168.0.40:9200/logs-modes/_bulk?pretty"" --data-binary @""C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed\Monitel_Modes_Host-2022-01-20-data-0.json"" ";
                
        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
        $pinfo.UseShellExecute = $false
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $pinfo
        $p.Start() | Out-Null
        $p.WaitForExit()
        $output = $p.StandardOutput.ReadToEnd()
        $output += $p.StandardError.ReadToEnd()
        $output

        #SaveTextLog -_File "curl.txt" -_Data "$($output)";
        
    }
    catch {
        Write-host Get-ErrorInformation $_;
       
        $result="false";
    }
    #$response=$response |  ConvertTo-Json;
   
   # Return $response;
}

SendData -_ElasticAddress $ElasticAddress -_FilesPath $FilesPath