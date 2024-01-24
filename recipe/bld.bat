@echo off
setlocal EnableDelayedExpansion

copy "%RECIPE_DIR%\build.sh" .
set PREFIX=%PREFIX:\=/%
set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1
set BUILD_PLATFORM=win_amd64

makedirs \tmp

bash -lc "./build.sh"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem Under windows it installs as secp256.lib, but under linux it installs as libsecp256k1.a
rem So we need to rename it to the correct name
move %PREFIX%\lib\secp256.dll.lib %PREFIX%\lib\libsecp256k1.dll.lib
move %PREFIX%\lib\secp256.lib %PREFIX%\lib\libsecp256k1.lib

move %PREFIX%\bin\secp256-1.dll %PREFIX%\bin\libsecp256k1-1.dll

exit /b 0


