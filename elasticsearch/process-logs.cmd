@echo off

SET SCRIPT_PATH=.\
SET SOURCE_PATH="C:\Projects\linux-dev\elk\elk-project\logs-examples"
SET DESTINATION_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs"
SET PROCESSED_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed"

SET MASK="*.log"
SET PARSER_PATH="C:\Projects\linux-dev\elk\elk-project\log-parser\log-parser\bin\Debug"
SET INDEX="logs-modes"
SET FILESIZE="10"

::powershell.exe %SCRIPT_PATH%\copy-logs.ps1 -SourcePath '%SOURCE_PATH%' -DestinationPath '%DESTINATION_PATH%' -Mask '%MASK%'
powershell.exe %SCRIPT_PATH%\process-logs.ps1 -Path '%DESTINATION_PATH%' -ProcessedPath '%PROCESSED_PATH%' -Mask '%MASK%' -ParserPath '%PARSER_PATH%' -Index '%INDEX%' -FileSize '%FILESIZE%'
