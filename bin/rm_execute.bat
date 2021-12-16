@echo off
title Run Map Launcher
set "RMCfg=bin\rm_config.ini"
set "ExecMeFile=Execute.exe"
set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem"
set "PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.JS"
bin\KillProc.exe kill "%ExecMeFile%"

:read_params
for /f "usebackq eol=# tokens=1,* delims=	=" %%a in ("%RMCfg%") do set "%%~a=%%~b"

:prepare
if /i not "%RunTask%"=="True" (
	color 0c
	echo.
	echo   Error: No game dir specified!
	pause>nul
	goto quit
)
if not defined MapFile (
	color 0c
	echo.
	echo   Error: No map file specified!
	pause>nul
	goto quit
)

call :get_starttime
echo ###############################################################################
echo #                                                                             #
echo #                             Preparing script                                #
echo #                                                                             #
echo ###############################################################################
echo.
echo Game Directory: "%GameDir%".
echo Compiling Map:  "%MapFile%.vmf".
echo.

echo>"%MapFile%.log" ================ Log started [%date%, %time:~0,-3%] =================
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" Game Directory: "%GameDir%".
echo>>"%MapFile%.log" Current Map: "%MapFile%.vmf".

if /i "%DelBSPs%"=="True" (
	if exist "%MapFile%.bsp" (
		del /f /q "%MapFile%.bsp" > nul
		echo Deleted old dump: "%MapFile%.bsp".
		echo>>"%MapFile%.log" Deleted old compilation: "%MapName%.bsp".
	)
)
if exist "%MapFile%.prt" (
	del /f /q "%MapFile%.prt" > nul
	echo Deleted old dump: "%MapFile%.prt".
	echo>>"%MapFile%.log" Deleted old compilation: "%MapName%.prt".
)
echo.>>"%MapFile%.log"
echo.
echo.


:run_vbsp
if /i not "%RunVbsp%"=="True" (goto run_vvis)
set "VbspCmdInfo=%VbspCmd%"
if "%VbspCmd%"=="       " set "VbspCmdInfo=[None]"
echo ###############################################################################
echo #                                                                             #
echo #                        Starting VBSP compilation                            #
echo #                                                                             #
echo ###############################################################################
echo Params: %VbspCmdInfo%
echo.

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ============ Started VBSP compilation [%date%, %time:~0,-3%] =============
echo>>"%MapFile%.log" Parameters: %VbspCmdInfo%
bin\vbsp.exe %VbspCmd% "%MapFile%"
if ErrorLevel 1 (call :if_error)
echo.>>"%MapFile%.log"
echo.
echo.


:run_vvis
if /i not "%RunVvis%"=="True" (goto run_vrad)
set "VvisCmdInfo=%VvisCmd%"
if "%VvisCmd%"=="       " set "VvisCmdInfo=[None]"
echo ###############################################################################
echo #                                                                             #
echo #                        Starting VVIS compilation                            #
echo #                                                                             #
echo ###############################################################################
echo Params: %VvisCmdInfo%
echo.

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ============ Started VVIS compilation [%date%, %time:~0,-3%] =============
echo>>"%MapFile%.log" Parameters: %VvisCmdInfo%
bin\vvis.exe %VvisCmd% "%MapFile%"
if ErrorLevel 1 (call :if_error)
echo.>>"%MapFile%.log"
echo.
echo.


:run_vrad
if /i not "%RunVrad%"=="True" (goto copy_file)
set "VradCmdInfo=%VradCmd%"
if "%VradCmd%"=="       " set "VradCmdInfo=[None]"
echo ###############################################################################
echo #                                                                             #
echo #                        Starting VRAD compilation                            #
echo #                                                                             #
echo ###############################################################################
echo Params: %VradCmdInfo%
echo.

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ============ Started VRAD compilation [%date%, %time:~0,-3%] ============
echo>>"%MapFile%.log" Parameters: %VradCmdInfo%
bin\vrad.exe %VradCmd% "%MapFile%"
if ErrorLevel 1 (call :if_error)
echo.>>"%MapFile%.log"
echo.
echo.


:copy_file
if /i not "%CopyBSP%"=="True" (goto run_man)
echo ###############################################################################
echo #                                                                             #
echo #                    Copying BSP file to game directory                       #
echo #                                                                             #
echo ###############################################################################
echo.
echo Source path: "%MapFile%.bsp"
echo Destination path: "%DestDir%\"
if not exist "%DestDir%" (md "%DestDir%">nul)

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ============ Managing compiled files [%date%, %time:~0,-3%] =============
echo.>>"%MapFile%.log"

echo.
echo Deleting previous compilation...
echo>>"%MapFile%.log" Deleting previous compilation...
if exist "%DestDir%\%MapName%.bsp" (
	del /f /q "%DestDir%\%MapName%.bsp" > nul
	echo File "%DestDir%\%MapName%.bsp" deleted.
	echo>>"%MapFile%.log" - Deleted: "%DestDir%\%MapName%.bsp".
) else (
	echo - Nothing to delete.
	echo>>"%MapFile%.log" - Nothing to delete.
)
echo.
echo Placing file to BSP directory...
echo>>"%MapFile%.log" Placing file to BSP directory...
echo>>"%MapFile%.log" - Source path: "%MapFile%.bsp"
echo>>"%MapFile%.log" - Destination path: "%DestDir%\"
if exist "%MapFile%.bsp" (
	copy /y "%MapFile%.bsp" "%DestDir%\" > nul
	echo File succesfully copied.
	echo>>"%MapFile%.log" - File succesfully copied.
) else (
	echo File "%MapFile%.bsp" not found.
	echo>>"%MapFile%.log" - Error: File "%MapFile%.bsp" not found.
)
echo.
echo Deleting compilation dumps...
echo>>"%MapFile%.log" Deleting compilation dumps...
if exist "%MapFile%.prt" (
	del /f /q "%MapFile%.prt" > nul
	echo Deleted: "%MapFile%.prt".
	echo>>"%MapFile%.log" - Deleted: "%MapFile%.prt".
) else (
	echo - No prt file exist.
	echo>>"%MapFile%.log" - No prt file exist.
)
if /i "%DelBSPs%"=="True" (
	if exist "%MapFile%.bsp" (
		del /f /q "%MapFile%.bsp" > nul
		echo Deleted: "%MapFile%.bsp".
		echo>>"%MapFile%.log" - Deleted: "%MapFile%.bsp".
	) else (
		echo - No bsp file exist.
		echo>>"%MapFile%.log" - No bsp file exist.
	)
)
echo.
echo.


:run_man
if /i not "%SewUsed%"=="True" (goto run_game)
echo ###############################################################################
echo #                                                                             #
echo #                     Sewing used game resources to map                       #
echo #                                                                             #
echo ###############################################################################
echo.
echo BSP file to pack in: "%MapFile%.bsp"
echo Dir for searching resources: "%GameDir%".
echo.
echo See compile log file to view MAN tool status.

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" =========== Started MAN to sew resources [%date%, %time:~0,-3%] ===========
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" Dir for searching resources:
echo>>"%MapFile%.log" "%GameDir%".
echo.>>"%MapFile%.log"
bin\man.exe -c "%DestDir%\%MapName%.bsp" -g "%GameDir%">>"%MapFile%.log"
echo.
echo.


:run_game
if /i not "%RunGame%"=="True" (goto show_time)
set "GameCmdInfo=%GameCmd%"
if "%GameCmd%"=="       " set "GameCmdInfo=[None]"
if exist "%GameDir%\GameInfo.txt" (
for /f "eol=/ usebackq tokens=1,2" %%m in ("%GameDir%\GameInfo.txt") do (
	if /i "%%~m"=="SteamAppId" (set "SteamAppId=%%~n")
))
echo ###############################################################################
echo #                                                                             #
echo #                             Starting Engine                                 #
echo #                                                                             #
echo ###############################################################################
echo.
echo GameDir: "%GameDir%"
echo GameExe: "%ExeFull%"
echo SteamAppId: %SteamAppId%
echo MapFile: "%MapName%.bsp"
echo Params: %GameCmdInfo%
echo.

echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ============= Starting map in game [%date%, %time:~0,-3%] ==============
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" GameDir: "%GameDir%"
echo>>"%MapFile%.log" GameExe: "%ExeFull%"
echo>>"%MapFile%.log" SteamAppId: %SteamAppId%
echo>>"%MapFile%.log" MapFile: "%MapName%.bsp"
echo>>"%MapFile%.log" Params:  %GameCmdInfo%

if /i not "%ExeExtn%"==".exe" (
	echo Error: Wrong game EXE file specified!
	echo.>>"%MapFile%.log"
	echo>>"%MapFile%.log" Error: Wrong game EXE file specified!
)

bin\KillProc.exe kill "%ExeFile%"
cd /d "%ExePath%"
if exist "..\..\..\Steam.exe" (
if not exist "*.ini" (
if not exist "steam.dll" (
if not exist "bin\steam.dll" (
	echo Game uses Steam for work, so running Steam to launch...
	echo.>>"%MapFile%.log"
	echo>>"%MapFile%.log" Game uses Steam for work, so running Steam to launch.
	pushd ..\..\..
	call :log_steampath

	for %%m in ("GreenLuma.dll" "SmartSteam.dll") do (
	if exist "%%~m" (
		echo Using ClientApp: %%~nm patcher.
		echo>>"%MapFile%.log" Using ClientApp: %%~nm patcher.
		start Steam.exe -clientapp "%%~m" -applaunch %SteamAppId% %GameCmd% +map "%MapName%" +con_enable 1
		popd
		goto show_time
	))

	start Steam.exe -applaunch %SteamAppId% %GameCmd% +map "%MapName%" +con_enable 1
	popd
	goto show_time
))))
start "game" "%ExeFile%" -game "%GameDir%" -appid %SteamAppId% -steam %GameCmd% +map "%MapName%" +con_enable 1



:show_time
for %%m in ("%RunVbsp%" "%RunVvis%" "%RunVrad%" "%SewUsed%") do (if /i "%%~m"=="True" goto show_ok)
goto view_log

:show_ok
echo.
echo.>>"%MapFile%.log"
echo.>>"%MapFile%.log"
call :get_elapsedtime
echo.


:view_log
if /i not "%ViewLog%"=="True" (goto close_log)
cd /d "%HomeDir%"

(echo [Options]
 echo Lang=1
 echo goback=0
 echo [OptLOG]
 echo deffontnfame=Lucida Sans Unicode
 echo fontclor=14737632
)>"bin\viewlog.ini"

bin\killproc.exe kill "viewlog.exe"
if exist "..\..\..\resources\bin\sfk.exe" (
 "..\..\..\resources\bin\sfk.exe" replace "%MapFile%.log" -spat "|...10|...10\r\n|" -spat "|...10\r\n\r\n|...10\r\n|" -yes> nul
 "..\..\..\resources\bin\sfk.exe" replace "%MapFile%.log" -spat "|...Building|...\r\nBuilding|" -spat "|...Done|...\r\nDone|" -yes> nul
)

echo Viewing log file: "%MapFile%.log"
echo.
start bin\viewlog.exe "%MapFile%.log"



:close_log
echo.>>"%MapFile%.log"
echo>>"%MapFile%.log" ================ Log closed [%date%, %time:~0,-3%] =================
echo Finished.

:quit
if exist "%RMCfg%" (del /f /q "%RMCfg%" > nul)
if /i not "%RunVbsp%"=="True" (
if /i not "%RunVvis%"=="True" (
if /i not "%RunVrad%"=="True" (
if /i not "%SewUsed%"=="True" (
exit))))
if /i not "%ViewLog%"=="True" (
pause > nul)
exit




:if_error
	echo.
	echo [-] An error occured during compiling your map.
	echo [-] See compile log for more details.
	pause > nul
	goto view_log
exit /b

:log_steampath
	echo Steam Path: "%cd%\Steam.exe".
	echo>>"%MapFile%.log" Steam Path: "%cd%\Steam.exe".
exit /b

:get_starttime
	for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
	   set /A "startt=(((%%~a*60)+1%%~b %% 100)*60+1%%~c %% 100)*100+1%%~d %% 100"
	)
exit /b

:get_elapsedtime
	:: get end time:
	for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
	   set /A "endt=(((%%~a*60)+1%%~b %% 100)*60+1%%~c %% 100)*100+1%%~d %% 100"
	)

	:: get elapsed time:
	set /A "elapsedt=endt-startt"

	:: show elapsed time:
	set /A "hh=elapsedt/(60*60*100), rest=elapsedt%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100"

	:: short variant
	rem if %mm% lss 10 set "mm=0%mm%"
	rem if %ss% lss 10 set "ss=0%ss%"
	rem if %cc% lss 10 set "cc=0%cc%"
	rem set "hh=%hh%:"
	rem set "mm=%mm%:"
	
	:: writing variant
	if "%hh%"=="0" (set "hh=") else (if "%hh%"=="1" (set "hh=1 hour ")   else (set "hh=%hh% hours "))
	if "%mm%"=="0" (set "mm=") else (if "%mm%"=="1" (set "mm=1 minute ") else (set "mm=%mm% minutes "))
	if "%ss%"=="1" (set "ss=1 second") else (set "ss=%ss% seconds")
	
	echo __________________________________________
	echo.
	echo Total time: %hh%%mm%%ss%.
	echo __________________________________________
	echo>>"%MapFile%.log" All operations completed.
	echo>>"%MapFile%.log" Total time: %hh%%mm%%ss%.
exit /b
