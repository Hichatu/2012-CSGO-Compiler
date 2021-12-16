@echo off
 set "RMCfg=bin\rm_config.ini"
 set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem"
 set "PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.JS"
 if /i "%~1"=="kill" (
	bin\wait.exe 30
	call taskkill /f /im "%~2"
 )

:prep_stage
 if /i "%~1"=="game" echo>"%RMCfg%" [Base]
 if /i "%~1"=="game" echo>>"%RMCfg%" RunTask	=	True
 if /i "%~1"=="game" echo>>"%RMCfg%" HomeDir	=	"%cd%"
 if /i "%~1"=="game" echo>>"%RMCfg%" GameDir	=	"%~2"
 if /i "%~1"=="map"  echo>>"%RMCfg%" MapFile	=	"%~2"
 if /i "%~1"=="map"  echo>>"%RMCfg%" MapName	=	"%~n2"

:vbsp_stage
 if /i "%~1"=="vbsp" echo.>>"%RMCfg%"
 if /i "%~1"=="vbsp" echo>>"%RMCfg%" [VBSP]
 if /i "%~1"=="vbsp" echo>>"%RMCfg%" RunVbsp	=	True
 if /i "%~1"=="vbsp" echo>>"%RMCfg%" VbspCmd	=	"%2 %3 %4 %5 %6 %7 %8 %9"

:vvis_stage
 if /i "%~1"=="vvis" echo.>>"%RMCfg%"
 if /i "%~1"=="vvis" echo>>"%RMCfg%" [VVIS]
 if /i "%~1"=="vvis" echo>>"%RMCfg%" RunVvis	=	True
 if /i "%~1"=="vvis" echo>>"%RMCfg%" VvisCmd	=	"%2 %3 %4 %5 %6 %7 %8 %9"

:vrad_stage
 if /i "%~1"=="vrad" echo.>>"%RMCfg%"
 if /i "%~1"=="vrad" echo>>"%RMCfg%" [VRAD]
 if /i "%~1"=="vrad" echo>>"%RMCfg%" RunVrad	=	True
 if /i "%~1"=="vrad" echo>>"%RMCfg%" VradCmd	=	"%2 %3 %4 %5 %6 %7 %8 %9"

:sew_stage
 if /i "%~1 %~2 %~3 %~4"=="used resources to .bsp" echo.>>"%RMCfg%"
 if /i "%~1 %~2 %~3 %~4"=="used resources to .bsp" echo>>"%RMCfg%" [ManTool]
 if /i "%~1 %~2 %~3 %~4"=="used resources to .bsp" echo>>"%RMCfg%" SewUsed	=	True

:copy_stage
 if /i "%~1 %~2 %~3"=="compiled map to" echo.>>"%RMCfg%"
 if /i "%~1 %~2 %~3"=="compiled map to" echo>>"%RMCfg%" [File]
 if /i "%~1 %~2 %~3"=="compiled map to" echo>>"%RMCfg%" CopyBSP	=	True
 if /i "%~1 %~2 %~3"=="compiled map to" echo>>"%RMCfg%" DestDir	=	"%~4"
 if /i "%~1 %~2 %~3 %~4"=="bsp from vmf's location" echo>>"%RMCfg%" DelBSPs	=	True

:game_stage
 if /i "%~x1"==".exe" echo.>>"%RMCfg%"
 if /i "%~x1"==".exe" echo>>"%RMCfg%" [Engine]
 if /i "%~x1"==".exe" echo>>"%RMCfg%" RunGame	=	True
 if /i "%~x1"==".exe" echo>>"%RMCfg%" ExeFull	=	"%~1"
 if /i "%~x1"==".exe" echo>>"%RMCfg%" ExePath	=	"%~dp1"
 if /i "%~x1"==".exe" echo>>"%RMCfg%" ExeFile	=	"%~nx1"
 if /i "%~x1"==".exe" echo>>"%RMCfg%" ExeExtn	=	"%~x1"
 if /i "%~x1"==".exe" echo>>"%RMCfg%" GameCmd	=	"%2 %3 %4 %5 %6 %7 %8 %9"

:vlog_stage
 if /i "%~1 %~2"=="compilation log" echo.>>"%RMCfg%"
 if /i "%~1 %~2"=="compilation log" echo>>"%RMCfg%" [Log]
 if /i "%~1 %~2"=="compilation log" echo>>"%RMCfg%" ViewLog	=	True
 if /i "%~1 %~2"=="compilation log" echo>>"%RMCfg%" LogFile	=	"%%MapFile%%.log"

exit
