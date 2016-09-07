@ECHO OFF
SETLOCAL
TITLE ASM Decompiler Helper
GOTO :EndComments



:EndComments

:: Program locations --==## START
:: HIEW
SET ASM.1="%USERPROFILE%\Desktop\lab files\hiew\hiew.exe"

:: dump
SET ASM.2=

:: Program locations --==## END

:: 
SET _myTGT=%1
IF NOT DEFINED _myTGT (
    GOTO :Syntax
)
FOR %%? IN (%_myTGT%) DO (
    ECHO file=%%~?
    ECHO filedrive=%%~d?
    ECHO filepath=%%~p?
    ECHO filename=%%~n?
    ECHO fileextension=%%~x?
)
PAUSE

ECHO %_myTGT%
PAUSE
DIR /B %_myTGT%
PAUSE

CALL :TIMEOUT 3

GOTO :EOF

:TIMEOUT
::Because Windows XP doesn't have the "timeout /T 2" command. Meh
SETLOCAL
PING -n %1 127.0.0.1 >NUL
EXIT /B

:Syntax
ECHO Empty Target
ECHO Please drag file on top of this batch file
CALL :TIMEOUT 3
