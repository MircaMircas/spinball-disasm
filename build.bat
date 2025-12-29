@echo off

REM set project_name=%~1
REM echo %project_name%
REM for %%f in ("%project_name%") do set project_name=%%~nf

if not exist "output\" mkdir output
if not exist "bin\" mkdir bin

set cmd_params=/k /p /o ae- spinball.asm, bin\spinbuilt.bin >output\spinball.log, , output\spinbuilt.lst

if exist bin\spinbuilt.bin (
  move /Y bin\spinbuilt.bin bin\spinbuilt.prev.bin >NUL
)

if exist asm68k.exe (
  asm68k %cmd_params%
  goto:assembler_completed
)

if exist axm68k.exe (
  axm68k %cmd_params%
  goto:assembler_completed
)

echo Could not find supported assembler. Currently expects asm68k.exe or axm68k.exe

:final_pause
echo:
@pause
goto:eof

:assembler_completed
type output\spinball.log
goto:final_pause
