@echo off
setlocal EnableDelayedExpansion

:: Prepare post-install tests
set "TEST_DIR=shared_standalone_tests"

echo DEBUG RECIPE_DIR is %RECIPE_DIR% or !RECIPE_DIR!
echo DEBUG TEST_DIR is %TEST_DIR% or "%TEST_DIR%" or !TEST_DIR! or "!TEST_DIR!"
echo DEBUG SRC_DIR is %SRC_DIR% or "%SRC_DIR%" or !SRC_DIR! or "!SRC_DIR!"

dir "%RECIPE_DIR%\!TEST_DIR!"

copy "%SRC_DIR%\src\tests.c" "%RECIPE_DIR%\!TEST_DIR!\src" > nul
copy "%SRC_DIR%\src\tests_exhaustive.c" "%RECIPE_DIR%\!TEST_DIR!\src" > nul
copy "%SRC_DIR%\src\secp256k1.c" "%RECIPE_DIR%\!TEST_DIR!\src" > nul

call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!" "%SRC_DIR%\src\*.h"
call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!" "%SRC_DIR%\src\modules\*\*.h"
call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!" "%SRC_DIR%\src\wycheproof\*.h"
call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!" "%SRC_DIR%\contrib\*.h"
call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!" "%SRC_DIR%\include\*.h"
call :CopyFiles "%SRC_DIR%" "%RECIPE_DIR%\!TEST_DIR!\src" "%SRC_DIR%\cmake\*"

:: Build environment
set "SECP256K1_BUILD_SHARED_LIBS=ON"
set "SECP256K1_INSTALL=ON"

set "BUILD_DIR=build"
mkdir %BUILD_DIR%
cd %BUILD_DIR%

:: Build and install
cmake %CMAKE_ARGS% ^
    -S %SRC_DIR% ^
    -B . ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D CMAKE_INSTALL_PREFIX=%PREFIX% ^
    -D CMAKE_INSTALL_BINDIR=Library\bin ^
    -D CMAKE_INSTALL_LIBDIR=Library\lib ^
    -D CMAKE_INSTALL_INCLUDEDIR=Library\include ^
    -D SECP256K1_ENABLE_MODULE_RECOVERY=ON ^
    -D BUILD_SHARED_LIBS=%SECP256K1_BUILD_SHARED_LIBS% ^
    -D SECP256K1_INSTALL=%SECP256K1_INSTALL% ^
    -D SECP256K1_BUILD_TESTS=ON ^
    -D SECP256K1_BUILD_EXHAUSTIVE_TESTS=OFF
if %ERRORLEVEL% neq 0 exit 1

cmake --build . --target install --config Release --clean-first
if %ERRORLEVEL% neq 0 exit 1

cd ..
rmdir /s /q %BUILD_DIR%

:: Duplicate windows library for -lsecp256k1 (from pkg-config) to work with MSVC
copy /y %PREFIX%\Library\lib\libsecp256k1.lib %PREFIX%\Library\lib\secp256k1.lib > nul

:: Replace unix / with windows \ in .pc file
setlocal EnableDelayedExpansion
for /f "tokens=*" %%a in (%PREFIX%\Library\lib\pkgconfig\libsecp256k1.pc) do (
  set "line=%%a"
  set "line=!line:/=\!"
  echo !line!>> tmplibsecp256k1.pc
)
endlocal
copy /y tmplibsecp256k1.pc %PREFIX%\Library\lib\pkgconfig\tmplibsecp256k1.pc > nul

:: move /y "%PKG_CONFIG_FILE%.tmp" "%PKG_CONFIG_FILE%" > nul

:CopyFiles
  set "LOCAL_SRC_DIR=%~1"
  set "LOCAL_TEST_DIR=%~2"
  set "LOCAL_SRC_DIR_FILES=%~3"

  for %%f in (%LOCAL_SRC_DIR_FILES%) do (
    set "FULL_PATH=%%~f"
    set "FILE=%%~nxf"
    set "FILE_PATH=!FULL_PATH:%LOCAL_SRC_DIR%\=!"
    set "DIR=!FILE_PATH:%%~nxf=!"

    rem Remove trailing backslash if exists
    if "!DIR:~-1!"=="\" set "DIR=!DIR:~0,-1!"

    if not exist "%LOCAL_TEST_DIR%\!DIR!" (
      echo Creating: "%LOCAL_TEST_DIR%\!DIR!"
      mkdir "%LOCAL_TEST_DIR%\!DIR!"
    )

    copy "%%~f" "%LOCAL_TEST_DIR%\!FILE_PATH!" > nul
    if %ERRORLEVEL% neq 0 exit /b 1
  )
exit /b 0


