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

rem Under windows it installs as secp256k1.lib
rem So we need to copy it to libsecp256k1.lib
rem and also copy the dll to libsecp256k1-1.dll

copy %PREFIX%\lib\secp256k1.lib %PREFIX%\lib\libsecp256k1.lib
copy %PREFIX%\lib\secp256k1.dll.lib %PREFIX%\lib\libsecp256k1.dll.lib

copy %PREFIX%\bin\secp256k1-1.dll %PREFIX%\bin\libsecp256k1-1.dll

exit /b 0


