param (
    [Parameter (Mandatory=$true)]
    [string]$SourcePath,

    [Parameter (Mandatory=$true)]
    [string]$DestinationPath,

    [Parameter (Mandatory=$true)]
    [string]$Mask

)

$date=(Get-date).AddDays(-1) | Get-Date -UFormat "%Y-%m-%d";

#List of files to be processed and written to Elastic
#Template should be changed (if necessary)
$files=@("Monitel_Modes_Host-$($date).log","Monitel_Modes_DataMonitor-$($date).log","Monitel_Modes_ZvkTransfer-$($date).log");

Function DeleteFiles () {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_Path,

        [Parameter(Mandatory=$true)]
        [string]$_Mask
    )
        
    try {
        Get-ChildItem -Path $_Path $_Mask | foreach { Remove-Item -Path $_.FullName }
    }
    catch {
        Write-warning Get-ErrorInformation $_;
    }
}

Function CopyFile () {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_File,

        [Parameter(Mandatory=$true)]
        [string]$_PathDestination
    )
        
    try {
        Copy-Item "$($_File)" -Destination "$($_PathDestination)"    
    }
    catch {
        Write-warning Get-ErrorInformation $_;
    }
}

#Clear directory from *.log files
DeleteFiles -_Path $DestinationPath -_Mask "$($Mask)"

$files | ForEach-Object {
   CopyFile -_File $($SourcePath+"\"+$_) -_PathDestination $DestinationPath;
}

