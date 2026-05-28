@echo off
title PC Optimizer Farhan
setlocal enabledelayedexpansion

:: BatchGotAdmin
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"="""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    cscript //nologo "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0" 

:start
cls
echo.
echo --------------------------------------------------
echo                   Optimizer
echo --------------------------------------------------
echo.

:: Options to select
echo *1.- Apply Recommended Optimizations
echo *2.- System Optimizations
echo *3.- Create Restore Point (Recommended)
echo *4.- Delete temporary files
echo *5.- Disable Windows Defender
echo *6.- Disable Windows Update
echo *7.- About the Optimizer
echo.

:: Options
set /p op=Option: 
if "%op%"=="" goto :start
if "%op%"=="1" goto :recommended
if "%op%"=="2" goto :optitweakspc
if "%op%"=="3" goto :restorepoint
if "%op%"=="4" goto :temp
if "%op%"=="5" goto :defender
if "%op%"=="6" goto :update
if "%op%"=="7" goto :about
if "%op%"=="" goto :Start

:recommended
cls

echo.
echo === Reducing svchost processes ===
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize"') do set MEM=%%i
set /a RAM=%MEM% + 1024000
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%RAM%" /f >nul 2>&1

echo.
echo === Disabling Wifi Sense ===
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi" /v AllowWiFiHotSpotReporting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi" /v AllowAutoConnectToWiFiSenseHotspots /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo === Disabling Windows Update Tasks ===
schtasks /Change /TN "\Microsoft\Windows\InstallService\*" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\*" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateAssistant\*" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WaaSMedic\*" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\*" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\WindowsUpdate\*" /Disable >nul 2>&1

echo.
echo === Optimizing Visual Section ===
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 200 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v KeyboardDelay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo === Disabling Teredo ===
netsh interface teredo set state disabled

echo.
echo === Disabling Telemetry Tasks ===
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\MareBackup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1

echo.
echo === Disabling Telemetry Registry ===
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo === Applying Registry Tweaks ===
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCmds" /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxThreads" /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCollectionCount" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Services\Ndu" /v Start /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d "400" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1

echo.
echo === Setting services to manual ===
sc config "AJRouter" start= demand >nul 2>&1
sc config "ALG" start= demand >nul 2>&1
sc config "AppIDSvc" start= demand >nul 2>&1
sc config "AppMgmt" start= demand >nul 2>&1
sc config "AppReadiness" start= demand >nul 2>&1
sc config "AppXSvc" start= demand >nul 2>&1
sc config "Appinfo" start= demand >nul 2>&1
sc config "AssignedAccessManagerSvc" start= demand >nul 2>&1
sc config "AxInstSV" start= demand >nul 2>&1
sc config "BDESVC" start= demand >nul 2>&1
sc config "BTAGService" start= demand >nul 2>&1
sc config "BcastDVRUserService_*" start= demand >nul 2>&1
sc config "BluetoothUserService_*" start= demand >nul 2>&1
sc config "Browser" start= demand >nul 2>&1
sc config "CaptureService_*" start= demand >nul 2>&1
sc config "CertPropSvc" start= demand >nul 2>&1
sc config "ClipSVC" start= demand >nul 2>&1
sc config "ConsentUxUserSvc_*" start= demand >nul 2>&1
sc config "CredentialEnrollmentManagerUserSvc_*" start= demand >nul 2>&1
sc config "CscService" start= demand >nul 2>&1
sc config "DcpSvc" start= demand >nul 2>&1
sc config "DevQueryBroker" start= demand >nul 2>&1
sc config "DeviceAssociationBrokerSvc_*" start= demand >nul 2>&1
sc config "DeviceAssociationService" start= demand >nul 2>&1
sc config "DeviceInstall" start= demand >nul 2>&1
sc config "DevicePickerUserSvc_*" start= demand >nul 2>&1
sc config "DevicesFlowUserSvc_*" start= demand >nul 2>&1
sc config "DisplayEnhancementService" start= demand >nul 2>&1
sc config "DmEnrollmentSvc" start= demand >nul 2>&1
sc config "DsSvc" start= demand >nul 2>&1
sc config "DsmSvc" start= demand >nul 2>&1
sc config "EFS" start= demand >nul 2>&1
sc config "EapHost" start= demand >nul 2>&1
sc config "EntAppSvc" start= demand >nul 2>&1
sc config "FDResPub" start= demand >nul 2>&1
sc config "Fax" start= demand >nul 2>&1
sc config "FrameServer" start= demand >nul 2>&1
sc config "FrameServerMonitor" start= demand >nul 2>&1
sc config "GraphicsPerfSvc" start= demand >nul 2>&1
sc config "HomeGroupListener" start= demand >nul 2>&1
sc config "HomeGroupProvider" start= demand >nul 2>&1
sc config "HvHost" start= demand >nul 2>&1
sc config "IEEtwCollectorService" start= demand >nul 2>&1
sc config "IKEEXT" start= demand >nul 2>&1
sc config "InstallService" start= demand >nul 2>&1
sc config "InventorySvc" start= demand >nul 2>&1
sc config "IpxlatCfgSvc" start= demand >nul 2>&1
sc config "KtmRm" start= demand >nul 2>&1
sc config "LicenseManager" start= demand >nul 2>&1
sc config "LxpSvc" start= demand >nul 2>&1
sc config "MSDTC" start= demand >nul 2>&1
sc config "MSiSCSI" start= demand >nul 2>&1
sc config "McpManagementService" start= demand >nul 2>&1
sc config "MessagingService_*" start= demand >nul 2>&1
sc config "MicrosoftEdgeElevationService" start= demand >nul 2>&1
sc config "MixedRealityOpenXRSvc" start= demand >nul 2>&1
sc config "NPSMSvc_*" start= demand >nul 2>&1
sc config "NaturalAuthentication" start= demand >nul 2>&1
sc config "NcaSvc" start= demand >nul 2>&1
sc config "NcbService" start= demand >nul 2>&1
sc config "NcdAutoSetup" start= demand >nul 2>&1
sc config "NetSetupSvc" start= demand >nul 2>&1
sc config "Netman" start= demand >nul 2>&1
sc config "NgcCtnrSvc" start= demand >nul 2>&1
sc config "NgcSvc" start= demand >nul 2>&1
sc config "NlaSvc" start= demand >nul 2>&1
sc config "P9RdrService_*" start= demand >nul 2>&1
sc config "PNRPAutoReg" start= demand >nul 2>&1
sc config "PNRPsvc" start= demand >nul 2>&1
sc config "PeerDistSvc" start= demand >nul 2>&1
sc config "PenService_*" start= demand >nul 2>&1
sc config "PerfHost" start= demand >nul 2>&1
sc config "PhoneSvc" start= demand >nul 2>&1
sc config "PimIndexMaintenanceSvc_*" start= demand >nul 2>&1
sc config "PlugPlay" start= demand >nul 2>&1
sc config "PolicyAgent" start= demand >nul 2>&1
sc config "PrintNotify" start= demand >nul 2>&1
sc config "PrintWorkflowUserSvc_*" start= demand >nul 2>&1
sc config "PushToInstall" start= demand >nul 2>&1
sc config "QWAVE" start= demand >nul 2>&1
sc config "RasAuto" start= demand >nul 2>&1
sc config "RasMan" start= demand >nul 2>&1
sc config "RetailDemo" start= demand >nul 2>&1
sc config "RmSvc" start= demand >nul 2>&1
sc config "RpcLocator" start= demand >nul 2>&1
sc config "SCPolicySvc" start= demand >nul 2>&1
sc config "SCardSvr" start= demand >nul 2>&1
sc config "SDRSVC" start= demand >nul 2>&1
sc config "SEMgrSvc" start= demand >nul 2>&1
sc config "SNMPTRAP" start= demand >nul 2>&1
sc config "SNMPTrap" start= demand >nul 2>&1
sc config "SSDPSRV" start= demand >nul 2>&1
sc config "ScDeviceEnum" start= demand >nul 2>&1
sc config "SecurityHealthService" start= demand >nul 2>&1
sc config "Sense" start= demand >nul 2>&1
sc config "SensorDataService" start= demand >nul 2>&1
sc config "SensorService" start= demand >nul 2>&1
sc config "SensrSvc" start= demand >nul 2>&1
sc config "SessionEnv" start= demand >nul 2>&1
sc config "SharedAccess" start= demand >nul 2>&1
sc config "SharedRealitySvc" start= demand >nul 2>&1
sc config "SmsRouter" start= demand >nul 2>&1
sc config "SstpSvc" start= demand >nul 2>&1
sc config "StiSvc" start= demand >nul 2>&1
sc config "TabletInputService" start= demand >nul 2>&1
sc config "TapiSrv" start= demand >nul 2>&1
sc config "TieringEngineService" start= demand >nul 2>&1
sc config "TimeBroker" start= demand >nul 2>&1
sc config "TimeBrokerSvc" start= demand >nul 2>&1
sc config "TokenBroker" start= demand >nul 2>&1
sc config "TroubleshootingSvc" start= demand >nul 2>&1
sc config "TrustedInstaller" start= demand >nul 2>&1
sc config "UI0Detect" start= demand >nul 2>&1
sc config "UdkUserSvc_*" start= demand >nul 2>&1
sc config "UmRdpService" start= demand >nul 2>&1
sc config "UnistoreSvc_*" start= demand >nul 2>&1
sc config "UserDataSvc_*" start= demand >nul 2>&1
sc config "VSS" start= demand >nul 2>&1
sc config "VacSvc" start= demand >nul 2>&1
sc config "W32Time" start= demand >nul 2>&1
sc config "WEPHOSTSVC" start= demand >nul 2>&1
sc config "WFDSConMgrSvc" start= demand >nul 2>&1
sc config "WMPNetworkSvc" start= demand >nul 2>&1
sc config "WManSvc" start= demand >nul 2>&1
sc config "WPDBusEnum" start= demand >nul 2>&1
sc config "WSService" start= demand >nul 2>&1
sc config "WaaSMedicSvc" start= demand >nul 2>&1
sc config "WalletService" start= demand >nul 2>&1
sc config "WarpJITSvc" start= demand >nul 2>&1
sc config "WbioSrvc" start= demand >nul 2>&1
sc config "WcsPlugInService" start= demand >nul 2>&1
sc config "WdNisSvc" start= demand >nul 2>&1
sc config "WdiServiceHost" start= demand >nul 2>&1
sc config "WdiSystemHost" start= demand >nul 2>&1
sc config "WebClient" start= demand >nul 2>&1
sc config "Wecsvc" start= demand >nul 2>&1
sc config "WerSvc" start= demand >nul 2>&1
sc config "WiaRpc" start= demand >nul 2>&1
sc config "WinHttpAutoProxySvc" start= demand >nul 2>&1
sc config "WinRM" start= demand >nul 2>&1
sc config "WpcMonSvc" start= demand >nul 2>&1
sc config "XblAuthManager" start= demand >nul 2>&1
sc config "XblGameSave" start= demand >nul 2>&1
sc config "XboxGipSvc" start= demand >nul 2>&1
sc config "XboxNetApiSvc" start= demand >nul 2>&1
sc config "autotimesvc" start= demand >nul 2>&1
sc config "bthserv" start= demand >nul 2>&1
sc config "camsvc" start= demand >nul 2>&1
sc config "cloudidsvc" start= demand >nul 2>&1
sc config "dcsvc" start= demand >nul 2>&1
sc config "defragsvc" start= demand >nul 2>&1
sc config "diagnosticshub.standardcollector.service" start= demand >nul 2>&1
sc config "diagsvc" start= demand >nul 2>&1
sc config "dmwappushservice" start= demand >nul 2>&1
sc config "dot3svc" start= demand >nul 2>&1
sc config "edgeupdate" start= demand >nul 2>&1
sc config "edgeupdatem" start= demand >nul 2>&1
sc config "embeddedmode" start= demand >nul 2>&1
sc config "fdPHost" start= demand >nul 2>&1
sc config "fhsvc" start= demand >nul 2>&1
sc config "hidserv" start= demand >nul 2>&1
sc config "icssvc" start= demand >nul 2>&1
sc config "lfsvc" start= demand >nul 2>&1
sc config "lltdsvc" start= demand >nul 2>&1
sc config "lmhosts" start= demand >nul 2>&1
sc config "msiserver" start= demand >nul 2>&1
sc config "netprofm" start= demand >nul 2>&1
sc config "p2pimsvc" start= demand >nul 2>&1
sc config "p2psvc" start= demand >nul 2>&1
sc config "perceptionsimulation" start= demand >nul 2>&1
sc config "pla" start= demand >nul 2>&1
sc config "seclogon" start= demand >nul 2>&1
sc config "smphost" start= demand >nul 2>&1
sc config "spectrum" start= demand >nul 2>&1
sc config "svsvc" start= demand >nul 2>&1
sc config "swprv" start= demand >nul 2>&1
sc config "upnphost" start= demand >nul 2>&1
sc config "vds" start= demand >nul 2>&1
sc config "vmicguestinterface" start= demand >nul 2>&1
sc config "vmicheartbeat" start= demand >nul 2>&1
sc config "vmickvpexchange" start= demand >nul 2>&1
sc config "vmicrdv" start= demand >nul 2>&1
sc config "vmicshutdown" start= demand >nul 2>&1
sc config "vmictimesync" start= demand >nul 2>&1
sc config "vmicvmsession" start= demand >nul 2>&1
sc config "vmicvss" start= demand >nul 2>&1
sc config "vmvss" start= demand >nul 2>&1
sc config "wbengine" start= demand >nul 2>&1
sc config "wcncsvc" start= demand >nul 2>&1
sc config "webthreatdefsvc" start= demand >nul 2>&1
sc config "wercplsupport" start= demand >nul 2>&1
sc config "wisvc" start= demand >nul 2>&1
sc config "wlidsvc" start= demand >nul 2>&1
sc config "wlpasvc" start= demand >nul 2>&1
sc config "wmiApSrv" start= demand >nul 2>&1
sc config "workfolderssvc" start= demand >nul 2>&1
sc config "wuauserv" start= demand >nul 2>&1
sc config "wudfsvc" start= demand >nul 2>&1

echo.
echo === Disabling Services ===
sc config "diagnosticshub.standardcollector.service" start= disabled >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1
sc config "DPS" start= disabled >nul 2>&1
sc config "FontCache" start= disabled >nul 2>&1
sc config "FontCache3.0.0.0" start= disabled >nul 2>&1
sc config "SystemUsageReportSvc_QUEENCREEK" start= disabled >nul 2>&1
sc config "GpuEnergyDrv" start= disabled >nul 2>&1
sc config "ShellHWDetection" start= disabled >nul 2>&1
sc config "SgrmAgent" start= disabled >nul 2>&1
sc config "SgrmBroker" start= disabled >nul 2>&1
sc config "uhssvc" start= disabled >nul 2>&1
sc config "TrkWks" start= disabled >nul 2>&1
sc config "WdiServiceHost" start= disabled >nul 2>&1
sc config "WdiSystemHost" start= disabled >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc config "diagsvc" start= disabled >nul 2>&1

echo === Clearing DNS cache ===
echo.
ipconfig /flushdns >nul 2>&1

echo.
echo === Applying Repository Master Recommended Profile ===
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Write-Host 'Applying Workstation Master Profile (Recommended)...'; & '%~dp0Profiles\Apply_Workstation_Master_Profile.ps1' -Force"

timeout /t 3 /nobreak
goto :done

:temp
echo.
echo Deleting Temporary Files...
del /S /F /Q "%temp%"
del /S /F /Q "%WINDIR%\Temp\*.*"
del /S /F /Q "%WINDIR%\Prefetch\*.*" 
echo.
goto :done

:restorepoint
cls

echo.
echo Creating restore point...
"powershell.exe" Enable-ComputerRestore -Drive "%SystemDrive%"
"powershell.exe" -Command "Checkpoint-Computer -Description 'Optimizer Script'"
goto :start

:defender
cls

echo --------------------------------------------------
echo                   Optimizer
echo --------------------------------------------------
echo.

:: Options to select
echo *1.- Disable Defender
echo *2.- Enable Defender
echo *3.- Go Back.
echo.

:: Code to go to menu with Options
set /p oput=Option: 
if "%oput%"=="1" goto :DF
if "%oput%"=="2" goto :DE
if "%oput%"=="3" goto :Start
if "%oput%"=="" goto :Start



:DF
cls
echo.
echo --------------------------------------------------
echo        Disabling Windows Defender
echo --------------------------------------------------
echo.
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotificationOnLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1
timeout /t 3 /nobreak
goto :Start



:DE
cls
echo.
echo --------------------------------------------------
echo            Enabling Windows Defender.
echo --------------------------------------------------
echo.
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotificationOnLockScreen" /t REG_DWORD /d 0 /f >nul 2>&1
timeout /t 3 /nobreak
goto :start

:optitweakspc
cls

echo --------------------------------------------------
echo                   Optimizer
echo --------------------------------------------------
echo.

:: Options to select
echo *1.- Set services to Manual
echo *2.- Disable Fullscreen Optimizations
echo *3.- Disable Telemetry
echo *4.- Disable unnecessary services
echo *5.- Disable background apps
echo *6.- Reduce Windows quality
echo *7.- High priority for Games
echo *8.- Reduce svchost processes
echo *9.- Disable GameDVR
echo *10.- Go Back
echo.

:: Options
set /p optwkpc=Option: 
if "%optwkpc%"=="" goto :start
if "%optwkpc%"=="1" goto :servicemanual
if "%optwkpc%"=="2" goto :disablefullscreenoptimizations
if "%optwkpc%"=="3" goto :disabletelemetry
if "%optwkpc%"=="4" goto :disableservices
if "%optwkpc%"=="5" goto :disablebackgroundapps
if "%optwkpc%"=="6" goto :reducewindows
if "%optwkpc%"=="7" goto :highprioritygame
if "%optwkpc%"=="8" goto :svchostprocess
if "%optwkpc%"=="9" goto :disablegamedvr
if "%optwkpc%"=="10" goto :start
if "%optwkpc%"=="" goto :Start

:servicemanual
cls

echo.
echo Setting services to manual...
sc config "AJRouter" start= demand >nul 2>&1
sc config "ALG" start= demand >nul 2>&1
sc config "AppIDSvc" start= demand >nul 2>&1
sc config "AppMgmt" start= demand >nul 2>&1
sc config "AppReadiness" start= demand >nul 2>&1
sc config "AppXSvc" start= demand >nul 2>&1
sc config "Appinfo" start= demand >nul 2>&1
sc config "AssignedAccessManagerSvc" start= demand >nul 2>&1
sc config "AxInstSV" start= demand >nul 2>&1
sc config "BDESVC" start= demand >nul 2>&1
sc config "BTAGService" start= demand >nul 2>&1
sc config "BcastDVRUserService_*" start= demand >nul 2>&1
sc config "BluetoothUserService_*" start= demand >nul 2>&1
sc config "Browser" start= demand >nul 2>&1
sc config "CaptureService_*" start= demand >nul 2>&1
sc config "CertPropSvc" start= demand >nul 2>&1
sc config "ClipSVC" start= demand >nul 2>&1
sc config "ConsentUxUserSvc_*" start= demand >nul 2>&1
sc config "CredentialEnrollmentManagerUserSvc_*" start= demand >nul 2>&1
sc config "CscService" start= demand >nul 2>&1
sc config "DcpSvc" start= demand >nul 2>&1
sc config "DevQueryBroker" start= demand >nul 2>&1
sc config "DeviceAssociationBrokerSvc_*" start= demand >nul 2>&1
sc config "DeviceAssociationService" start= demand >nul 2>&1
sc config "DeviceInstall" start= demand >nul 2>&1
sc config "DevicePickerUserSvc_*" start= demand >nul 2>&1
sc config "DevicesFlowUserSvc_*" start= demand >nul 2>&1
sc config "DisplayEnhancementService" start= demand >nul 2>&1
sc config "DmEnrollmentSvc" start= demand >nul 2>&1
sc config "DsSvc" start= demand >nul 2>&1
sc config "DsmSvc" start= demand >nul 2>&1
sc config "EFS" start= demand >nul 2>&1
sc config "EapHost" start= demand >nul 2>&1
sc config "EntAppSvc" start= demand >nul 2>&1
sc config "FDResPub" start= demand >nul 2>&1
sc config "Fax" start= demand >nul 2>&1
sc config "FrameServer" start= demand >nul 2>&1
sc config "FrameServerMonitor" start= demand >nul 2>&1
sc config "GraphicsPerfSvc" start= demand >nul 2>&1
sc config "HomeGroupListener" start= demand >nul 2>&1
sc config "HomeGroupProvider" start= demand >nul 2>&1
sc config "HvHost" start= demand >nul 2>&1
sc config "IEEtwCollectorService" start= demand >nul 2>&1
sc config "IKEEXT" start= demand >nul 2>&1
sc config "InstallService" start= demand >nul 2>&1
sc config "InventorySvc" start= demand >nul 2>&1
sc config "IpxlatCfgSvc" start= demand >nul 2>&1
sc config "KtmRm" start= demand >nul 2>&1
sc config "LicenseManager" start= demand >nul 2>&1
sc config "LxpSvc" start= demand >nul 2>&1
sc config "MSDTC" start= demand >nul 2>&1
sc config "MSiSCSI" start= demand >nul 2>&1
sc config "McpManagementService" start= demand >nul 2>&1
sc config "MessagingService_*" start= demand >nul 2>&1
sc config "MicrosoftEdgeElevationService" start= demand >nul 2>&1
sc config "MixedRealityOpenXRSvc" start= demand >nul 2>&1
sc config "NPSMSvc_*" start= demand >nul 2>&1
sc config "NaturalAuthentication" start= demand >nul 2>&1
sc config "NcaSvc" start= demand >nul 2>&1
sc config "NcbService" start= demand >nul 2>&1
sc config "NcdAutoSetup" start= demand >nul 2>&1
sc config "NetSetupSvc" start= demand >nul 2>&1
sc config "Netman" start= demand >nul 2>&1
sc config "NgcCtnrSvc" start= demand >nul 2>&1
sc config "NgcSvc" start= demand >nul 2>&1
sc config "NlaSvc" start= demand >nul 2>&1
sc config "P9RdrService_*" start= demand >nul 2>&1
sc config "PNRPAutoReg" start= demand >nul 2>&1
sc config "PNRPsvc" start= demand >nul 2>&1
sc config "PeerDistSvc" start= demand >nul 2>&1
sc config "PenService_*" start= demand >nul 2>&1
sc config "PerfHost" start= demand >nul 2>&1
sc config "PhoneSvc" start= demand >nul 2>&1
sc config "PimIndexMaintenanceSvc_*" start= demand >nul 2>&1
sc config "PlugPlay" start= demand >nul 2>&1
sc config "PolicyAgent" start= demand >nul 2>&1
sc config "PrintNotify" start= demand >nul 2>&1
sc config "PrintWorkflowUserSvc_*" start= demand >nul 2>&1
sc config "PushToInstall" start= demand >nul 2>&1
sc config "QWAVE" start= demand >nul 2>&1
sc config "RasAuto" start= demand >nul 2>&1
sc config "RasMan" start= demand >nul 2>&1
sc config "RetailDemo" start= demand >nul 2>&1
sc config "RmSvc" start= demand >nul 2>&1
sc config "RpcLocator" start= demand >nul 2>&1
sc config "SCPolicySvc" start= demand >nul 2>&1
sc config "SCardSvr" start= demand >nul 2>&1
sc config "SDRSVC" start= demand >nul 2>&1
sc config "SEMgrSvc" start= demand >nul 2>&1
sc config "SNMPTRAP" start= demand >nul 2>&1
sc config "SNMPTrap" start= demand >nul 2>&1
sc config "SSDPSRV" start= demand >nul 2>&1
sc config "ScDeviceEnum" start= demand >nul 2>&1
sc config "SecurityHealthService" start= demand >nul 2>&1
sc config "Sense" start= demand >nul 2>&1
sc config "SensorDataService" start= demand >nul 2>&1
sc config "SensorService" start= demand >nul 2>&1
sc config "SensrSvc" start= demand >nul 2>&1
sc config "SessionEnv" start= demand >nul 2>&1
sc config "SharedAccess" start= demand >nul 2>&1
sc config "SharedRealitySvc" start= demand >nul 2>&1
sc config "SmsRouter" start= demand >nul 2>&1
sc config "SstpSvc" start= demand >nul 2>&1
sc config "StiSvc" start= demand >nul 2>&1
sc config "TabletInputService" start= demand >nul 2>&1
sc config "TapiSrv" start= demand >nul 2>&1
sc config "TieringEngineService" start= demand >nul 2>&1
sc config "TimeBroker" start= demand >nul 2>&1
sc config "TimeBrokerSvc" start= demand >nul 2>&1
sc config "TokenBroker" start= demand >nul 2>&1
sc config "TroubleshootingSvc" start= demand >nul 2>&1
sc config "TrustedInstaller" start= demand >nul 2>&1
sc config "UI0Detect" start= demand >nul 2>&1
sc config "UdkUserSvc_*" start= demand >nul 2>&1
sc config "UmRdpService" start= demand >nul 2>&1
sc config "UnistoreSvc_*" start= demand >nul 2>&1
sc config "UserDataSvc_*" start= demand >nul 2>&1
sc config "VSS" start= demand >nul 2>&1
sc config "VacSvc" start= demand >nul 2>&1
sc config "W32Time" start= demand >nul 2>&1
sc config "WEPHOSTSVC" start= demand >nul 2>&1
sc config "WFDSConMgrSvc" start= demand >nul 2>&1
sc config "WMPNetworkSvc" start= demand >nul 2>&1
sc config "WManSvc" start= demand >nul 2>&1
sc config "WPDBusEnum" start= demand >nul 2>&1
sc config "WSService" start= demand >nul 2>&1
sc config "WaaSMedicSvc" start= demand >nul 2>&1
sc config "WalletService" start= demand >nul 2>&1
sc config "WarpJITSvc" start= demand >nul 2>&1
sc config "WbioSrvc" start= demand >nul 2>&1
sc config "WcsPlugInService" start= demand >nul 2>&1
sc config "WdNisSvc" start= demand >nul 2>&1
sc config "WdiServiceHost" start= demand >nul 2>&1
sc config "WdiSystemHost" start= demand >nul 2>&1
sc config "WebClient" start= demand >nul 2>&1
sc config "Wecsvc" start= demand >nul 2>&1
sc config "WerSvc" start= demand >nul 2>&1
sc config "WiaRpc" start= demand >nul 2>&1
sc config "WinHttpAutoProxySvc" start= demand >nul 2>&1
sc config "WinRM" start= demand >nul 2>&1
sc config "WpcMonSvc" start= demand >nul 2>&1
sc config "XblAuthManager" start= demand >nul 2>&1
sc config "XblGameSave" start= demand >nul 2>&1
sc config "XboxGipSvc" start= demand >nul 2>&1
sc config "XboxNetApiSvc" start= demand >nul 2>&1
sc config "autotimesvc" start= demand >nul 2>&1
sc config "bthserv" start= demand >nul 2>&1
sc config "camsvc" start= demand >nul 2>&1
sc config "cloudidsvc" start= demand >nul 2>&1
sc config "dcsvc" start= demand >nul 2>&1
sc config "defragsvc" start= demand >nul 2>&1
sc config "diagnosticshub.standardcollector.service" start= demand >nul 2>&1
sc config "diagsvc" start= demand >nul 2>&1
sc config "dmwappushservice" start= demand >nul 2>&1
sc config "dot3svc" start= demand >nul 2>&1
sc config "edgeupdate" start= demand >nul 2>&1
sc config "edgeupdatem" start= demand >nul 2>&1
sc config "embeddedmode" start= demand >nul 2>&1
sc config "fdPHost" start= demand >nul 2>&1
sc config "fhsvc" start= demand >nul 2>&1
sc config "hidserv" start= demand >nul 2>&1
sc config "icssvc" start= demand >nul 2>&1
sc config "lfsvc" start= demand >nul 2>&1
sc config "lltdsvc" start= demand >nul 2>&1
sc config "lmhosts" start= demand >nul 2>&1
sc config "msiserver" start= demand >nul 2>&1
sc config "netprofm" start= demand >nul 2>&1
sc config "p2pimsvc" start= demand >nul 2>&1
sc config "p2psvc" start= demand >nul 2>&1
sc config "perceptionsimulation" start= demand >nul 2>&1
sc config "pla" start= demand >nul 2>&1
sc config "seclogon" start= demand >nul 2>&1
sc config "smphost" start= demand >nul 2>&1
sc config "spectrum" start= demand >nul 2>&1
sc config "svsvc" start= demand >nul 2>&1
sc config "swprv" start= demand >nul 2>&1
sc config "upnphost" start= demand >nul 2>&1
sc config "vds" start= demand >nul 2>&1
sc config "vmicguestinterface" start= demand >nul 2>&1
sc config "vmicheartbeat" start= demand >nul 2>&1
sc config "vmickvpexchange" start= demand >nul 2>&1
sc config "vmicrdv" start= demand >nul 2>&1
sc config "vmicshutdown" start= demand >nul 2>&1
sc config "vmictimesync" start= demand >nul 2>&1
sc config "vmicvmsession" start= demand >nul 2>&1
sc config "vmicvss" start= demand >nul 2>&1
sc config "vmvss" start= demand >nul 2>&1
sc config "wbengine" start= demand >nul 2>&1
sc config "wcncsvc" start= demand >nul 2>&1
sc config "webthreatdefsvc" start= demand >nul 2>&1
sc config "wercplsupport" start= demand >nul 2>&1
sc config "wisvc" start= demand >nul 2>&1
sc config "wlidsvc" start= demand >nul 2>&1
sc config "wlpasvc" start= demand >nul 2>&1
sc config "wmiApSrv" start= demand >nul 2>&1
sc config "workfolderssvc" start= demand >nul 2>&1
sc config "wuauserv" start= demand >nul 2>&1
sc config "wudfsvc" start= demand >nul 2>&1

timeout /t 3 /nobreak
goto :done

:disablefullscreenoptimizations
cls

echo.
echo Disabling Fullscreen Optimizations...

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1

timeout /t 3 /nobreak
goto :done

:disabletelemetry
cls

echo.
echo Disabling Telemetry Registry...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1

timeout /t 3 /nobreak
goto :done

:disableservices
cls

echo.
echo === Disabling Services ===
sc config "DiagTrack" start= disabled >nul 2>&1
sc config "DPS" start= disabled >nul 2>&1
sc config "FontCache" start= disabled >nul 2>&1
sc config "FontCache3.0.0.0" start= disabled >nul 2>&1
sc config "SystemUsageReportSvc_QUEENCREEK" start= disabled >nul 2>&1
sc config "GpuEnergyDrv" start= disabled >nul 2>&1
sc config "ShellHWDetection" start= disabled >nul 2>&1
sc config "SgrmAgent" start= disabled >nul 2>&1
sc config "SgrmBroker" start= disabled >nul 2>&1
sc config "uhssvc" start= disabled >nul 2>&1
sc config "WdiServiceHost" start= disabled >nul 2>&1
sc config "WdiSystemHost" start= disabled >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc config "diagsvc" start= disabled >nul 2>&1

timeout /t 3 /nobreak
goto :done

:disablebackgroundapps
cls

echo Disabling background applications
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1

timeout /t 3 /nobreak
goto :done

:reducewindows
cls

echo.
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 200 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v KeyboardDelay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f >nul 2>&1

timeout /t 3 /nobreak
goto :done


:highprioritygame
cls

echo.
echo Setting high priority for games...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csgo.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cs2.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gta_3.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gta_vc.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gta_sa.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTAIV.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\java.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\minecraft.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\obs32.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\obs64.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PPSSPP.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ShellExperienceHost.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 5 /f >nul 2>&1
goto :done

:svchostprocess
cls

echo Reducing svchost processes...
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /format:value') do set MEM=%%i
set /a RAM=%MEM% + 1024000
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%RAM%" /f >nul 2>&1

timeout /t 3 /nobreak
goto :done

:disablegamedvr
cls

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1

timeout /t 3 /nobreak
goto :done

:update
cls

echo --------------------------------------------------
echo                   Optimizer
echo --------------------------------------------------
echo.

:: Options to select
echo *1.- Disable Windows Update
echo *2.- Enable Windows Update
echo *3.- Go Back.
echo.

:: Code to go to menu with Options
set /p oput=Option: 
if "%oput%"=="1" goto :WA
if "%oput%"=="2" goto :WD
if "%oput%"=="3" goto :Start
if "%oput%"=="" goto :Start


:WA
cls

:: Disable update related services
for %%i in (wuauserv, UsoSvc, uhssvc, WaaSMedicSvc) do (
	net stop %%i
sc config %%i start= disabled >nul 2>&1
	sc failure %%i reset= 0 actions= ""
)

:: Brute force rename services
for %%i in (WaaSMedicSvc, wuaueng) do (
	takeown /f C:\Windows\System32\%%i.dll && icacls C:\Windows\System32\%%i.dll /grant *S-1-1-0:F
	rename C:\Windows\System32\%%i.dll %%i_BAK.dll
	icacls C:\Windows\System32\%%i_BAK.dll /setowner "NT SERVICE\TrustedInstaller" && icacls C:\Windows\System32\%%i_BAK.dll /remove *S-1-1-0
)

:: Update registry
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v FailureActions /t REG_BINARY /d 000000000000000000000000030000001400000000000000c0d4010000000000e09304000000000000000000 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1

:: Delete downloaded update files
erase /f /s /q c:\windows\softwaredistribution\*.* && rmdir /s /q c:\windows\softwaredistribution

:: Disable all update related scheduled tasks
schtasks /change /tn "\Microsoft\Windows\InstallService\*" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\UpdateOrchestrator\*" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\UpdateAssistant\*" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WaaSMedic\*" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\*" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\WindowsUpdate\*" /disable >nul 2>&1

:: Go Back
timeout /t 3 /nobreak
goto :update  

:WD
cls
:: Enable update related services
sc config wuauserv start= auto >nul 2>&1
sc config UsoSvc start= auto >nul 2>&1
sc config uhssvc start= delayed-auto >nul 2>&1

:: Restore renamed services
for %%i in (WaaSMedicSvc, wuaueng) do (
	takeown /f C:\Windows\System32\%%i_BAK.dll && icacls C:\Windows\System32\%%i_BAK.dll /grant *S-1-1-0:F
	rename C:\Windows\System32\%%i_BAK.dll %%i.dll
	icacls C:\Windows\System32\%%i.dll /setowner "NT SERVICE\TrustedInstaller" && icacls C:\Windows\System32\%%i.dll /remove *S-1-1-0
)

:: Update registry
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v FailureActions /t REG_BINARY /d 840300000000000000000000030000001400000001000000c0d4010001000000e09304000000000000000000 /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f

:: Enable all update related scheduled tasks
schtasks /change /tn "\Microsoft\Windows\InstallService\*" /enable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\UpdateOrchestrator\*" /enable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\UpdateAssistant\*" /enable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WaaSMedic\*" /enable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\*" /enable >nul 2>&1
schtasks /change /tn "\Microsoft\WindowsUpdate\*" /enable >nul 2>&1

:: Go Back
timeout /t 3 /nobreak
goto :update

:about
cls

echo ---------------------------------------------------------------------------------
echo                                 Optimizer
echo ---------------------------------------------------------------------------------
echo.
echo A simple and efficient PC optimizer to increase performance on low-end systems.
echo Special credits to Farhan for the optimizations.
echo.
echo ---------------------------------------------------------------------------------
echo.

:: Code to go to menu with Options
pause
goto :start

:done
cls
echo --------------------------------------------------
echo            Optimization completed!
echo --------------------------------------------------
echo.
echo Your operating system was optimized correctly!	  
echo Please restart your PC to notice the change.
echo.
echo --------------------------------------------------
timeout /t 3 /nobreak
goto :start
