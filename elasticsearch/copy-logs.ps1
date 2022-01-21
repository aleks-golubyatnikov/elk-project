param (
    [Parameter (Mandatory=$true)]
    [string]$SourcePath,

    [Parameter (Mandatory=$true)]
    [string]$DestinationPath,

    [Parameter (Mandatory=$true)]
    [string]$Mask

)
. .\service.ps1

$date=(Get-date).AddDays(-1) | Get-Date -UFormat "%Y-%m-%d";
$_date=(Get-date).AddDays(0) | Get-Date -UFormat "%Y-%m-%d";
$_log="$($_date)-logs-process.txt";
        
#List of files to be processed and written to Elastic
#Template should be changed (if necessary)
#"Monitel_Modes_DataMonitor-$($date).log","Monitel_Modes_ZvkTransfer-$($date).log"
$files=@("Monitel_Modes_Host-$($date).log","Monitel_Modes_DataMonitor-$($date).log","Monitel_Modes_ZvkTransfer-$($date).log");

#Clear directory from *.log files

$f=DeleteFiles -_Path $DestinationPath -_Mask "$($Mask)" -ErrorAction Stop;
if($f -eq "true" ){
    SaveTextLog -_File "$($_log)" -_Data "Files '$($Mask)' in '$($DestinationPath)' were deleted"; 
}

$files | ForEach-Object {
    $f=CopyFile -_File $($SourcePath+"\"+$_) -_PathDestination $DestinationPath -ErrorAction Stop;
    if($f -eq "true"){
        SaveTextLog -_File "$($_log)" -_Data "'$($_)' was copied to '$($DestinationPath)'"; 
   }
}