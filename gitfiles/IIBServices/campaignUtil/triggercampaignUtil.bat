@echo off
REM ==================================================================
REM = triggercampaignUtil.cmd
REM =
REM = Command script used to trigger campaign util 
.
REM ==================================================================

setlocal ENABLEDELAYEDEXPANSION


:ParseDone


:BuildCommand

set CMD=curl

set CMD=%CMD% -v -k http://localhost:7080/loadcampignstorediscache

%CMD%


goto Bye

:Bye

endlocal
