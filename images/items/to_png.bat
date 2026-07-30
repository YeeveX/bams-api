@echo off
setlocal enabledelayedexpansion

:: Check for FFmpeg
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo FFmpeg not found. Please install FFmpeg and add it to your PATH.
    pause
    exit /b
)

:: Set target directory (default to current directory if no argument is provided)
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" (
    set "TARGET_DIR=%cd%"
)

:: Remove trailing slash if present for consistency
if "%TARGET_DIR:~-1%"=="\" set "TARGET_DIR=%TARGET_DIR:~0,-1%"

echo Target Directory: "%TARGET_DIR%"
echo Starting High-Quality Conversion...
echo.

:: Loop through .webp files in the target directory
for %%f in ("%TARGET_DIR%\*.webp") do (
    echo Converting: "%%~nxf"
    
    :: Convert to PNG
    ffmpeg -y -i "%%f" -vcodec png -compression_level 0 "%TARGET_DIR%\%%~nf.png" >nul 2>&1
    
    :: Verify if the PNG was created successfully before deleting the source
    if exist "%TARGET_DIR%\%%~nf.png" (
        echo Success! Deleting source: "%%~nxf"
        del "%%f"
    ) else (
        echo [ERROR] Failed to convert "%%~nxf". Keeping original file.
    )
    echo --------------------------------------------------
)

echo.
echo Conversion process complete!
pause