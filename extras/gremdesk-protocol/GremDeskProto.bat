@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "ARG=%~1"
set "CLIP=%~2"
rem Remove the prefix
set "ARG=%ARG:gremdesk://=%"

rem echo Clipboard: %CLIP%

rem Trim any trailing slash or backslash
:trimloop
if "%ARG:~-1%"=="/" set "ARG=%ARG:~0,-1%" & goto trimloop
if "%ARG:~-1%"=="\" set "ARG=%ARG:~0,-1%" & goto trimloop

echo Launching: %ARG%

if /I "%ARG%"=="photoshop" (
  start "" "C:\Program Files\Adobe\Adobe Photoshop 2025\Photoshop.exe"
  exit /b
)

if /I "%ARG:~0,9%"=="explorer/" (
  set "ENC=%ARG:~9%"

  rem Special: gremdesk://explorer/thispc
  if /I "!ENC!"=="thispc" (
    start "" explorer.exe "shell:MyComputerFolder"
    exit /b
  )

  set "GD_ENC=!ENC!"
  for /f "usebackq delims=" %%I in (`
    powershell -NoProfile -Command ^
      "$s=$env:GD_ENC; $s=$s.Replace('+',' '); [System.Uri]::UnescapeDataString($s)"
  `) do set "RAW=%%I"

  start "" explorer.exe "!RAW!"
  exit /b
)


if /I "%ARG%"=="4k_mode" (
  start "" "C:\Gremster\MultiMonitorTool\Set_Config1.bat"
  exit /b
)

if /I "%ARG%"=="gaming_mode" (
  start "" "C:\Gremster\MultiMonitorTool\Set_Config2.bat"
  exit /b
)

if /I "%ARG%"=="sublime" (
  start "" "C:\Program Files\Sublime Text\sublime_text.exe"
  exit /b
)

if /I "%ARG%"=="discord" (
  start "" "C:\Users\Gremlin\AppData\Local\Discord\Update.exe" --processStart "Discord.exe"
  exit /b
)

if /I "%ARG%"=="everything" (
  start "" "C:\Program Files (x86)\Everything\Everything.exe"
  exit /b
)

if /I "%ARG%"=="stablediffusion" (
  pushd "C:\Gremster\AI\stable-diffusion-webui"
  start "" "webui-user.bat"
  popd
  exit /b
)

if /I "%ARG%"=="comfyui" (
  start "" "C:\Gremster\AI\ComfyUI\ComfyUI.exe"
  exit /b
)

if /I "%ARG%"=="4chan" (
  start "" cmd /c "cd /d C:\Gremster\4chan-downloader && python inb4404.py --no-new-dir "%CLIP%""
  exit /b
)

if /I "%ARG%"=="ytdlp/video" (
  cd /d C:\Gremster\yt-dlp
  yt-dlp.exe --config-location "C:\Gremster\yt-dlp\yt-dlp.conf" "%CLIP%"
  pause
  exit /b
)

if /I "%ARG%"=="ytdlp/audio" (
  cd /d C:\Gremster\yt-dlp
  yt-dlp.exe --config-location "C:\Gremster\yt-dlp\audio.conf" "%CLIP%"
  pause
  exit /b
)

echo Unknown command: %ARG%
pause

:URLDECODE
setlocal EnableDelayedExpansion
set "s=!%~1!"

rem minimal URL decode for paths
set "s=!s:+= !"

set "s=!s:%20= !"
set "s=!s:%5C=\!"
set "s=!s:%2F=/!"
set "s=!s:%3A=:!"

set "s=!s:%20= !"
set "s=!s:%5c=\!"
set "s=!s:%2f=/!"
set "s=!s:%3a=:!"

endlocal & set "%~1=%s%"
exit /b
