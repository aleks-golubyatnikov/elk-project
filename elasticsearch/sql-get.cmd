@echo off

SET SERVER="golubyatnikov-3"
SET DATABASE="AdventureWorks2017"
SET USER="etl_reader"
SET PASSWORD="etl_reader"
SET OUTFILE="data-sql.json"
SET INDEX="logs-energy"
SET SCRIPT_PATH=.\

powershell.exe %SCRIPT_PATH%\sql-parser.ps1 -Server '%SERVER%' -Database '%DATABASE%' -User '%USER%' -Password '%PASSWORD%' -OutFile %OUTFILE% -Index '%INDEX%'