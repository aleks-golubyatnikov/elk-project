param (
    [Parameter (Mandatory=$true)]
    [string]$Path,

    [Parameter (Mandatory=$true)]
    [string]$ProcessedPath,

    [Parameter (Mandatory=$true)]
    [string]$Mask,

    [Parameter (Mandatory=$true)]
    [string]$ParserPath,

    [Parameter (Mandatory=$true)]
    [string]$Index,

    [Parameter (Mandatory=$true)]
    [string]$FileSize,

    [Parameter (Mandatory=$true)]
    [string]$RowsCount
)

. .\service.ps1

$_date=(Get-date).AddDays(0) | Get-Date -UFormat "%Y-%m-%d";
$_log="$($_date)-logs-process.txt";

Function ProcessLogs () {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_Path,

        [Parameter(Mandatory=$true)]
        [string]$_ProcessedPath,

        [Parameter(Mandatory=$true)]
        [string]$_Mask,

        [Parameter(Mandatory=$true)]
        [string]$_ParserPath,

        [Parameter(Mandatory=$true)]
        [string]$_Index,

        [Parameter(Mandatory=$true)]
        [string]$_FileSize,

        [Parameter(Mandatory=$true)]
        [string]$_RowsCount
    )

    $result="true";
    
    try {
        Get-ChildItem "$($_Path)" -Filter $_Mask | Foreach-Object {
            
            #Start-Process "notepad.exe" -NoNewWindow -Wait;
            #Write-host $Parser; 
            #Write-host $Params; 
            
            $Parser=$_ParserPath+"\log-parser.exe";
            $_name=$_.Name.Substring(0,$_.Name.IndexOf('.'))+"-data";
            $Params="$($([System.Net.Dns]::GetHostName())) ""$($_.FullName)"" ""$($_ProcessedPath)\\"" ""$($_name)"" $($_Index) $($_FileSize) $($_RowsCount)";
            $cmd=$Parser+" "+$Params;
            
            SaveTextLog -_File "$($_log)" -_Data "Started processing the file '$($_.FullName)' ";
            Start-Process -FilePath "$Parser" -ArgumentList $Params -Wait;
        }
    }
    catch {
        Write-warning Get-ErrorInformation $_;
        $result="false";
    }

    return $result;
}

#Clear directory from *.log files
$f=DeleteFiles -_Path $ProcessedPath -_Mask "*.json" -ErrorAction Stop;
if($f -eq "true" ){
    SaveTextLog -_File "$($_log)" -_Data "Files '*.json' in '$($ProcessedPath)' were deleted"; 
}

$f=ProcessLogs -_Path $Path -_ProcessedPath $ProcessedPath -_Mask $Mask -_ParserPath $ParserPath -_Index $Index -_FileSize $FileSize -_RowsCount $RowsCount
if($f -eq "true"){
    SaveTextLog -_File "$($_log)" -_Data "File processing completed"; 
}