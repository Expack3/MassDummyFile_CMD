SET /A "Counter=0"
IF "%~3" == "1" GOTO One
IF "%~3" == "2" GOTO Two
IF "%~3" == "3" GOTO Three
IF "%~2" == "3" (
GOTO Three
)
ELSE (
GOTO Usage
)

:One
SET "Folder=%~1"
SET "Extension=%~2"
IF "%Folder%"=="" GOTO Usage
IF "%Extension%"=="" GOTO Usage
IF "%Folder:~-1%"=="\" SET "Folder=%Folder:~0,-1%"
IF "%Extension:~0,1%"=="." SET "Extension=%Extension:~1%"
FOR /F "usebackq delims=" %%I IN ( `dir /b "%Folder%\*.%Extension%"` ) DO (
COPY /y NUL "%Folder%\%%I"
IF EXIST "%Folder%\%%I" SET /A "Counter+=1"
)
IF %Counter% NEQ 0 (
ECHO "%Counter% dummy file(s) created."
) ELSE (
ECHO No files with the .bak extension exist.
)
GOTO EndBatch

:Two
SET "Folder=%~1"
SET "Extension=%~2"
IF "%Folder%"=="" GOTO Usage
IF "%Extension%"=="" GOTO Usage
IF "%Folder:~-1%"=="\" SET "Folder=%Folder:~0,-1%"
IF "%Extension:~0,1%"=="." SET "Extension=%Extension:~1%"
FOR /F "usebackq delims=" %%I IN ( `dir /b "%Folder%\*.%Extension%"` ) DO (
COPY "%Folder%\%%I" "%Folder%\%%I.bak" >NUL
IF EXIST "%Folder%\%%I.bak" SET /A "Counter+=1"
)
IF %Counter% NEQ 0 (
ECHO "%Counter% file(s) backed up."
) ELSE (
ECHO No files with the .bak extension exist.
)
GOTO EndBatch

:Three
SET "Folder=%~1"
SET "Extension=bak"
IF "%Folder%"=="" GOTO Usage
IF "%Extension%"=="" GOTO Usage
IF "%Folder:~-1%"=="\" SET "Folder=%Folder:~0,-1%"
IF "%Extension:~0,1%"=="." SET "Extension=%Extension:~1%"
FOR /F "usebackq tokens=1,2,3 delims=." %%I IN ( `dir /b "%Folder%\*.%Extension%"` ) DO (
IF EXIST "%Folder%\%%I.%%J.%%K" SET /A "Counter+=1"
move /y "%Folder%\%%I.%%J.%%K" "%Folder%\%%I.%%J"
)
IF %Counter% NEQ 0 (
ECHO "%Counter% file(s) restored."
) ELSE (
ECHO No files with the .bak extension exist.
)
GOTO EndBatch

:Usage
CLS
ECHO Usage: %~n0 ["][Drive:]Path["] Extension OperationType
ECHO.
ECHO Examples:
ECHO.
ECHO    %~n0 "C:\My Files\" txt 1
ECHO.
ECHO    %~n0 C:\Temp\ doc 2
ECHO.
PAUSE

:EndBatch
SET Folder=
SET Extension=
SET Counter=