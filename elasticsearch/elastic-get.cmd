@echo off

SET REQUEST="http://192.168.0.40:9200/_cat/indices?pretty&format=json"
SET METHOD="GET"
SET CONTENTTYPE="application/json; charset=utf-8"
SET SCRIPT_PATH=.\

powershell.exe %SCRIPT_PATH%\elastic.ps1 -Method '%METHOD%' -ContentType '%CONTENTTYPE%' -Request '%REQUEST%'