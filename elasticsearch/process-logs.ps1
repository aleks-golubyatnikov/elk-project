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
    [string]$FileSize

)

Function ProcessLogs () {
    [CmdletBinding()]
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
        [string]$_FileSize

    )
        
    try {
        Get-ChildItem "$($_Path)" -Filter $_Mask | Foreach-Object {
            
            #Start-Process "notepad.exe" -NoNewWindow -Wait;
            #Write-host $Parser; 
            
            $Parser=$_ParserPath+"\log-parser.exe";
            $Params="$($([System.Net.Dns]::GetHostName())) ""$($_.FullName)"" ""$($_ProcessedPath)"" data $($_Index) $($_FileSize)";

            Write-host $Params; 
            #Start-Process "$($Parser) " -NoNewWindow -Wait;
            
            #Start-Process "$($Parser) $($([System.Net.Dns]::GetHostName())) $($_.FullName) $($_ProcessedPath) data $($_Index) $($_FileSize)" -NoNewWindow -Wait;
        }
    }
    catch {
        Write-warning Get-ErrorInformation $_;
    }
}

ProcessLogs -_Path $Path -_ProcessedPath $ProcessedPath -_Mask $Mask -_ParserPath $ParserPath -_Index $Index -_FileSize $FileSize