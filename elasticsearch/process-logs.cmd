@echo off

SET ELASTICADDRESS="http://192.168.0.40:9200/"
SET CONTENTTYPE="application/json; charset=utf-8"

SET SCRIPT_PATH=.\
SET SOURCE_PATH="\\IA-MODES2-TST\Log"
SET DESTINATION_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs"
SET PROCESSED_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed"

SET MASK="*.log"
SET INFO_MASK="*.info"

SET PARSER_PATH="C:\Projects\linux-dev\elk\elk-project\log-parser\log-parser\bin\Debug"
SET INDEX="logs-modes"
SET FILESIZE="30"
SET ROWSCOUNT="1000"

powershell.exe %SCRIPT_PATH%\copy-logs.ps1 -SourcePath '%SOURCE_PATH%' -DestinationPath '%DESTINATION_PATH%' -Mask '%MASK%'
powershell.exe %SCRIPT_PATH%\process-logs.ps1 -Path '%DESTINATION_PATH%' -ProcessedPath '%PROCESSED_PATH%' -Mask '%MASK%' -ParserPath '%PARSER_PATH%' -Index '%INDEX%' -FileSize '%FILESIZE%' -RowsCount '%ROWSCOUNT%'
call %SCRIPT_PATH%send-logs.cmd

SET ROOT_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\\"
SET INFO_MASK="*.info"

powershell.exe %SCRIPT_PATH%\compress.ps1 -Path '%ROOT_PATH%' -Mask '%INFO_MASK%'
call %SCRIPT_PATH%elastic-get.cmd
