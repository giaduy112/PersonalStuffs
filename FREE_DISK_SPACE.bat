@ECHO OFF

REM Get Arguments
SET ARG_DRIVE_LETTER=%1^:
SET ARG_CLEAN_LIMIT=%2
SET ARG_CLEAN_PATHS=%~3
SET ARG_OLD_DAYS=%4

REM Query Free Bytes from Inputted Drive
FOR /f "usebackq tokens=1,2 delims==" %%A IN (`wmic logicaldisk where "Name like "%%ARG_DRIVE_LETTER%%"" get freespace /VALUE ^| FINDSTR "="`) DO (SET FREEBYTES=%%B)

REM Workaround the 32-bit signed Integer (-2^31 to 2^31-1) limitation of CMD operators by cutting off the last 6 digits & 1 blank space of the free bytes which will results in Megabytes instead of Bytes
SET /a CONVERTED_FREESPACE=%FREEBYTES:~0,-7%

REM Output the free space of inputted drive
IF %CONVERTED_FREESPACE% LEQ 1000 (
	SET UNIT_NAME=MBs
	SET DENOMINATOR=1
) ELSE (
	SET UNIT_NAME=GBs
	SET DENOMINATOR=1024
)
SET /a OUTPUT_RESULT=%CONVERTED_FREESPACE%/%DENOMINATOR%
ECHO "Free Space of Drive %ARG_DRIVE_LETTER% is %OUTPUT_RESULT% %UNIT_NAME%"

REM Check the Free Space with the Clean Limit
IF %CONVERTED_FREESPACE% LEQ %ARG_CLEAN_LIMIT% (
	ECHO "Critical free space left! Scripts will remove to-be-cleaned-up path(s) %ARG_CLEAN_PATHS%"
	
	REM Free Up Space by deleting files that are older than inputted # of days if free space is critical
	FOR %%I IN (%ARG_CLEAN_PATHS%) DO (
		FORFILES -p %%I -s -d %ARG_OLD_DAYS% -c "CMD /c IF @ISDIR==FALSE DEL /f /q /s @FILE"
		FORFILES -p %%I -s -d %ARG_OLD_DAYS% -c "CMD /c IF @ISDIR==TRUE RMDIR @FILE /s /q"
	)
) ELSE (
	ECHO "Not critical free space left. No need to clean up yet"
)

REM Exit the routine
EXIT /b