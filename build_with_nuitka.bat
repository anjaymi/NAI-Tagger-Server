@echo off
setlocal
cd /d "%~dp0"
echo [1/3] Checking dependencies...
py -m pip install fastapi uvicorn pillow numpy onnxruntime pandas huggingface_hub rembg tqdm nuitka ordered-set zstandard --quiet

echo [2/3] Building with Nuitka...
echo This will take a while...

REM Nuitka compilation command
REM --standalone: Include all dependencies
REM --onefile: Create a single EXE
REM --plugin-enable=numpy: Special handling for numpy
REM --include-package=uvicorn: Ensure uvicorn is included
REM --output-dir=dist: Output folder

py -m nuitka --standalone --onefile ^
    --plugin-enable=numpy ^
    --include-package=uvicorn ^
    --include-package=fastapi ^
    --include-package=rembg ^
    --include-package=onnxruntime ^
    --output-dir=dist ^
    --output-filename=tagger-server-x86_64-pc-windows-msvc.exe ^
    --enable-console ^
    tagger_server.py

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo [3/3] Moving binary...
if not exist "..\binaries" mkdir "..\binaries"
move /Y "dist\tagger-server-x86_64-pc-windows-msvc.exe" "..\binaries\"

echo Done!
