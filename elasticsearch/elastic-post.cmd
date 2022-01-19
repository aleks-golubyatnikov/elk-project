@echo off

SET REQUEST="http://192.168.0.40:9200/logs-modes/_bulk?pretty"
SET METHOD="POST"
SET CONTENTTYPE="application/json; charset=utf-8"
SET SCRIPT_PATH=.\
SET PARSER_PATH=..\log-parser\log-parser\bin\Debug\
SET JSON_PATH="data.json"
SET INDEX="logs-modes"

start /WAIT %PARSER_PATH%\log-parser.exe ia-modes-1 Monitel_Modes_Host-2021-10-27.log %JSON_PATH% %INDEX%
echo "finish"
::powershell.exe %SCRIPT_PATH%\elastic.ps1 -Method '%METHOD%' -ContentType '%CONTENTTYPE%' -Request '%REQUEST%' -FilePath %JSON_PATH%
