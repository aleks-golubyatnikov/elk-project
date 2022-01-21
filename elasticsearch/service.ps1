Function SaveTextLog() {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_file,

        [Parameter(Mandatory=$true)]
        [string]$_data
    )
    try {
        $date_time=Get-Date -UFormat "%Y-%m-%d %H:%M:%S";
        $date_time+" "+$_data | out-file -Encoding "UTF8" -filepath $_file -append
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
}

Function DeleteFiles () {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_Path,

        [Parameter(Mandatory=$true)]
        [string]$_Mask
    )
    
    $result="true";

    try {
        Get-ChildItem -Path $_Path $_Mask | foreach { Remove-Item -Path $_.FullName }
    }
    catch {
        Write-warning Get-ErrorInformation $_;
        $result="false";
    }
    return $result;
}

Function CopyFile () {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$_File,

        [Parameter(Mandatory=$true)]
        [string]$_PathDestination
    )

    $result="true";

    try {
        Copy-Item "$($_File)" -Destination "$($_PathDestination)";
    }
    catch {
        $formatstring = "{0} : {1}`n{2}`n" + "    + CategoryInfo          : {3}`n" + "    + FullyQualifiedErrorId : {4}`n";
        
        $fields = $_.InvocationInfo.MyCommand.Name, $_.ErrorDetails.Message, $_.InvocationInfo.PositionMessage, $_.CategoryInfo.ToString(),$_.FullyQualifiedErrorId;
        $e=$formatstring -f $fields;
        
        SaveTextLog -_File "$($_log)" -_Data "$($e)"; 
        Write-host "$($e)";
        
        $result="false";
    }

    return $result;
}