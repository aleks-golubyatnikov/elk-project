@echo off

SET ELASTICADDRESS="http://192.168.0.40:9200"
SET CONTENTTYPE="application/json"

SET PROCESSED_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed\"
SET ROOT_PATH="C:\Projects\linux-dev\elk\elk-project\elasticsearch\"

SET INDEX="logs-modes"

SET DTIME=%date:~-4%-%date:~3,2%-%date:~0,2%

For /R %ROOT_PATH% %%G IN (*.info) do (
    del /s /q /f %%G
)

For /R %PROCESSED_PATH% %%G IN (*.json) do (
    curl -XPOST -H "Content-Type: %CONTENTTYPE%" "%ELASTICADDRESS%/%INDEX%/_bulk?pretty" --data-binary @"%%G" >> "%DTIME%_%%~nG_json-upload.info"
    del /s /q /f %%G
)
