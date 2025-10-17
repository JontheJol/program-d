@echo off
echo Generando ejecutable para Windows...
echo.

REM Verificar si PyInstaller está instalado
pip show pyinstaller >nul 2>&1
if %errorlevel% neq 0 (
    echo PyInstaller no está instalado. Instalando...
    pip install pyinstaller
    if %errorlevel% neq 0 (
        echo Error al instalar PyInstaller
        pause
        exit /b 1
    )
)

echo Creando ejecutable...
pyinstaller --onefile --windowed --add-data "templates;templates" --add-data "static;static" --name MetodosNumericos.exe run.py

if %errorlevel% equ 0 (
    echo.
    echo ¡Ejecutable creado exitosamente!
    echo Ubicación: dist\MetodosNumericos.exe
    echo.
    echo Presiona cualquier tecla para abrir la carpeta dist...
    pause >nul
    start "" "dist"
) else (
    echo.
    echo Error al crear el ejecutable
    echo Revisa los mensajes de error anteriores
    pause
)