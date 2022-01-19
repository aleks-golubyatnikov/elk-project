param (
    [Parameter (Mandatory=$true)]
    [string]$Server,

    [Parameter (Mandatory=$true)]
    [string]$Database,
    
    [Parameter (Mandatory=$true)]
    [string]$User,
        
    [Parameter (Mandatory=$true)]
    [string]$Password,

    [Parameter (Mandatory=$false)]
    [string]$OutFile,

    [Parameter (Mandatory=$false)]
    [string]$Index
)

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

Function GetDataFromSQL () {
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory=$true)]
        [string]$_Server,

        [Parameter (Mandatory=$true)]
        [string]$_Database,
        
        [Parameter (Mandatory=$true)]
        [string]$_User,
            
        [Parameter (Mandatory=$true)]
        [string]$_Password,

        [Parameter (Mandatory=$false)]
        [string]$_Query,

        [Parameter (Mandatory=$false)]
        [string]$_OutFile,

        [Parameter (Mandatory=$false)]
        [string]$_Index
    )
        
    try {
        $data="";
        $logs=Invoke-Sqlcmd -ServerInstance $_Server -Database $_Database -Query "SELECT TOP 5 [BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName] FROM [Person].[Person]";
        foreach ($log in $logs) {
            $timestamp="";
            $module="";
            $message="";
            $message_cleared= Cleardata $message;
            $severity="";
            
            $data+="{`"index`": {`"_index`": `"$_Index`"}}`r`n";
            $data+="{`"timestamp`": `"$((Get-Date).ToString("yyyy-MM-dd"))T$timestamp`",`"node`": `"$local`", `"severity`": `"$severity`", `"module`": `"$module`", `"message`": `"$message_cleared`"}`r`n";
        }
        SaveToFile "$_OutFile" $data;
    }
    catch {
        Write-host Get-ErrorInformation $_;
    }
    Return $Response | ConvertTo-Json;
}

GetDataFromSQL -_Server $Server -_Database $Database -_User $User -_Password $Password -_OutFile $OutFile -_Index $Index;