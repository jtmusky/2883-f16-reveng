::ORG       N/A
::Copyright Unlicense
::NAME      ASM-Helper.bat
::PURPOSE   Expedite helper for Reverse Engineering Command.
::AUTHOR    Justin Musgrove <jtmusky@gmail.com>
::Revision  00.00.01 20160513

@ECHO OFF
SETLOCAL
TITLE ASM Decompiler Helper
GOTO :EndComments

Revision:   00.00.01 20160907 - JM: Initial Version
                - Empty shell

GOALS KEY:  X Complete, C CANX, M Moved, p particial
PRIORITY:   1 HIGH, 2 MED, 3 LOW

GOALS:      - Sanity Checks: Ensure program will run gooooood
                3:[ ] Windows Version check, WinXP, Win7
                2:[ ] Detect between dir and file, run different
                1:[ ] Ensure gracefull, or glorious crashes

            - Tool choice for user
                1:[ ] Prompt user for type of output

            - Working area
                1:[ ] Desktop working folder based on time
                1:[ ] Copy original file with pre-fix "MOD-"
                2:[ ] Verbose debug output of the file
                2:[ ] Record information of the target file


LICENSE:
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>

:EndComments

CALL :CurrentTime
ECHO %myTime%
PAUSE
GOTO :EOF

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

:: Functions ##==-- START ------------------------------------------------------

:TIMEOUT
::Because Windows XP doesn't have the "timeout /T 2" command. Meh
SETLOCAL
PING -n %1 127.0.0.1 >NUL
EXIT /B

:CurrentTime
:: Set Global variable myTime
:: Lets home that we always have 24H clock

:: SET SET D.Full=%DATE:~10%%DATE:~7,2%%DATE:~4,2%
:: Pull date from "builtin date variable"
SET D.Y=%DATE:~10%
SET D.M=%DATE:~7,2%
SET D.D=%DATE:~4,2%

:: SET T.Full=%TIME:~0,2%%TIME:~3,2%.%TIME:~6,2%
:: Pull time from "builtin time variable"
SET T.H=%TIME:~0,2%
SET T.M=%TIME:~3,2%
SET T.S=%TIME:~6,2%

:: Set time based on the above
:: SET myTime=%D.Full%-%T.Full%
SET myTime=%D.Y%%D.M%%D.D%-%T.H%%T.M%.%T.S%

EXIT /B

:Syntax
ECHO Empty Target
ECHO Please drag file on top of this batch file
CALL :TIMEOUT 3

:: Functions ##==-- END
