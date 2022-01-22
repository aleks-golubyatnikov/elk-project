param (
    [Parameter (Mandatory=$true)]
    [string]$Path,
    
    [Parameter (Mandatory=$true)]
    [string]$Mask

)
. .\service.ps1

$date=(Get-date).AddDays(-1) | Get-Date -UFormat "%Y-%m-%d";
$_date=(Get-date).AddDays(0) | Get-Date -UFormat "%Y-%m-%d";
$_log="$($_date)-logs-process.txt";

SaveTextLog -_File "$($_log)" -_Data "Started creating an archive '$($_date)_loaded-data.zip'"; 

Remove-Item "$($_date)_loaded-data.zip" -ErrorAction SilentlyContinue;
Compress-Archive -Path "$($Path)$($Mask)" -DestinationPath "$($Path)$($_date)_loaded-data.zip"

$f=DeleteFiles -_Path $Path -_Mask "$($Mask)" -ErrorAction Stop;
if($f -eq "true" ){
    SaveTextLog -_File "$($_log)" -_Data "Files '$($Mask)' in '$($Path)' were deleted"; 
}

SaveTextLog -_File "$($_log)" -_Data "File upload operations completed"; 

