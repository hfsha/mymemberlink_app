@echo off
REM CopyFolder.bat - Copies contents from one folder to another

REM Set the source and destination folders
set "source=C:\xampp\htdocs\mymemberlink_backend"
set "destination=C:\Users\Shahidatul Hidayah\OneDrive\Documents\GitHub\mymemberlink_app\server\mymemberlink_backend"

REM Check if source folder exists
if not exist "%source%" (
    echo Source folder "%source%" does not exist.
    goto :eof
)

REM Create destination folder if it doesn't exist
if not exist "%destination%" (
    mkdir "%destination%"
)

REM Copy files and subdirectories from source to destination
xcopy "%source%\*" "%destination%\" /E /I /Y

echo Files have been copied successfully from "%source%" to "%destination%".
pause