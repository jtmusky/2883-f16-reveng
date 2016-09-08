::ORG       N/A
::Copyright Unlicense
::NAME      ASM-Helper.bat
::PURPOSE   Expedite helper for Reverse Engineering Command.
::AUTHOR    Justin Musgrove <jtmusky@gmail.com>
::Revision  00.00.01 20160513

@ECHO OFF
SETLOCAL
TITLE ASM Decompiler Helper
MODE CON COLS=80 LINES=25
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


:: Program locations ##==-- START
:: HIEW
SET ASM.1="%USERPROFILE%\Desktop\lab files\hiew\hiew.exe"

:: dump
::SET ASM.2="%ProgramFiles%\Microsoft Visual Studio .NET 2003\Vc7\bin\dumpbin.exe"
SET ASM.2="%ProgramFiles%\Microsoft Visual Studio .NET 2003\Common7\IDE\dumpbin.exe"

:: Program locations ##==-- END

:: Main ##==-- START

:: Parse file into sections to work with
SET _dragIN=%1
IF NOT DEFINED _dragIN (
    GOTO :Syntax
)
FOR %%? IN (%_dragIN%) DO (
    SET TGT.path=%%~dp?
    SET TGT.name=%%~nx?
)
SET TGT.SRC="%TGT.path%\%TGT.name%"

:: Function DragIN --==## END

:: Grag current time
CALL :CurrentTime

:: Create Play ground
CALL :WorkingDir PlayGround


:: Menu Loop ##==-- START
:MLoop.1
SET userChoice=
CLS
ECHO Detected File: %TGT.name%
ECHO PlayGround:    \Desktop\PlayGround\%myTime%-%TGT.name%
ECHO.
ECHO Directory Contents:
DIR /B
ECHO.
ECHO 1).....Start HIEW Tool
ECHO.
ECHO 2).....Start dumpbin
ECHO.
ECHO Anything else to quit
ECHO.

SET /P userChoice=Choose: 

IF "%userChoice%" == "1" GOTO :TOOL.HIEW
IF "%userChoice%" == "2" GOTO :TOOL.dumpbin
:: IF /I "%userChoice" == "Q" GOTO :EOF


:: Menu Loop ##==-- END
:: Main ##==-- END

START .
GOTO :EOF

:: Functions ##==-- START ------------------------------------------------------
:TOOL.HIEW

FOR %%? IN (PLAY-%TGT.name%) DO SET TGT.sname=%%~s?
%ASM.1% %TGT.sname%

GOTO :MLoop.1

:TOOL.dumpbin

IF NOT DEFINED VS71COMNTOOLS (
    "C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\bin\vcvars32.bat"
)

FOR %%? IN (data idata rdata) DO (
    %ASM.2% /RAWDATA:BYTES /SECTION:.%%? PLAY-%TGT.name% > %%?section.txt
)

GOTO :MLoop.1


:: Function Workingdir ##==--------------------------------------------------------
:Workingdir
:: Set the working directory to play in
SET DIR.BASE=%USERPROFILE%\Desktop\%~1\%myTime%-%TGT.name%
MKDIR "%DIR.BASE%"
PUSHD "%DIR.BASE%"
SET /P M=Creating playground copies of %TGT.name%... <NUL
FOR %%? IN (ORIG PLAY) DO ( 
    COPY %TGT.SRC% %%?-%TGT.name% >NUL
)
ECHO DONE
CALL :TIMEOUT 3
EXIT /B

:: Function TIMEOUT ##==--------------------------------------------------------
:TIMEOUT
::Because Windows XP doesn't have the "timeout /T 2" command. Meh
SETLOCAL

PING -n %1 127.0.0.1 >NUL

EXIT /B

:: function CurrentTime ##==----------------------------------------------------
:CurrentTime
:: Set Global variable myTime
:: Lets hope that we always have 24H clock

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
SET myTime=%D.Y%%D.M%%D.D%-%T.H: =0%%T.M%.%T.S%

EXIT /B

:: Function Syntax ##==---------------------------------------------------------
:Syntax
COLOR C
TITLE ASM Decompiler Helper: No File
CLS
ECHO.
ECHO    Empty Target
ECHO            Please drag file on top of this batch file
CALL :TIMEOUT 6

:: Functions ##==-- END
