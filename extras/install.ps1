# extras\install.ps1
# GremDesk install helper (portable, per-user, no admin):
# - Optional: register gremdesk:// protocol (HKCU)
# - Optional: auto-start server at login (Startup folder shortcut, silent)

$ErrorActionPreference = "Stop"

function Prompt-YesNo([string]$q, [bool]$defaultYes = $true) {
  $suffix = if ($defaultYes) { "[Y/n]" } else { "[y/N]" }
  while ($true) {
    $ans = Read-Host "$q $suffix"
    if ([string]::IsNullOrWhiteSpace($ans)) { return $defaultYes }
    switch -Regex ($ans.Trim()) {
      '^(y|yes)$' { return $true }
      '^(n|no)$'  { return $false }
      default     { Write-Host "Please answer y or n." }
    }
  }
}

function Get-RepoRoot([string]$startDir) {
  $cur = (Resolve-Path $startDir).Path
  while ($true) {
    if (Test-Path (Join-Path $cur "index.html")) { return $cur }
    if (Test-Path (Join-Path $cur "README.md"))  { return $cur }
    $parent = Split-Path $cur -Parent
    if ($parent -eq $cur) {
      throw "Could not find repo root (index.html or README.md). StartDir=$startDir"
    }
    $cur = $parent
  }
}

function Register-ProtocolPerUser([string]$protoVbsPath) {
  if (!(Test-Path $protoVbsPath)) { throw "Missing protocol VBS: $protoVbsPath" }

  # Per-user protocol registration (no admin). Writes under HKCU:\Software\Classes (merged into HKCR view).
  $base = "HKCU:\Software\Classes\gremdesk"
  New-Item -Path $base -Force | Out-Null
  New-ItemProperty -Path $base -Name "(Default)" -Value "URL:GremDesk Protocol" -Force | Out-Null
  New-ItemProperty -Path $base -Name "URL Protocol" -Value "" -Force | Out-Null

  $cmdKey = Join-Path $base "shell\open\command"
  New-Item -Path $cmdKey -Force | Out-Null

  $wscript = Join-Path $env:WINDIR "System32\wscript.exe"
  $command = '"' + $wscript + '" "' + (Resolve-Path $protoVbsPath).Path + '" "%1"'

  New-ItemProperty -Path $cmdKey -Name "(Default)" -Value $command -Force | Out-Null
  Write-Host "Registered gremdesk:// protocol (per-user)."
}

function Create-StartupShortcut([string]$repoRoot) {
  $launcher = Join-Path $repoRoot "extras\gremdesk-server\LaunchGremDeskServer.vbs"
  if (!(Test-Path $launcher)) {
    throw "Missing server launcher: $launcher"
  }

  $startupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
  if (!(Test-Path $startupDir)) {
    New-Item -ItemType Directory -Path $startupDir -Force | Out-Null
  }

  $shortcutPath = Join-Path $startupDir "GremDesk Server.lnk"
  $wscript = Join-Path $env:WINDIR "System32\wscript.exe"

  $ws = New-Object -ComObject WScript.Shell
  $sc = $ws.CreateShortcut($shortcutPath)
  $sc.TargetPath = $wscript
  $sc.Arguments  = "`"$launcher`""
  $sc.WorkingDirectory = $repoRoot
  $sc.IconLocation = "$wscript,0"
  $sc.Save()

  Write-Host "Created startup shortcut: $shortcutPath"
}

function Remove-StartupShortcut() {
  $startupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
  $shortcutPath = Join-Path $startupDir "GremDesk Server.lnk"
  if (Test-Path $shortcutPath) {
    Remove-Item -LiteralPath $shortcutPath -Force
    Write-Host "Removed startup shortcut: $shortcutPath"
  } else {
    Write-Host "Startup shortcut not found (nothing to remove)."
  }
}

# ---- main ----

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot  = Get-RepoRoot $scriptDir

$doProto   = Prompt-YesNo "Register gremdesk:// protocol?" $true
$doStartup = Prompt-YesNo "Auto-start server at login (Startup folder shortcut)?" $true

if ($doProto) {
  $protoVbs = Join-Path $repoRoot "extras\gremdesk-protocol\GremDeskProto.vbs"
  Register-ProtocolPerUser $protoVbs
}

if ($doStartup) {
  Create-StartupShortcut $repoRoot
} else {
  # Optional cleanup if user says no
  $remove = Prompt-YesNo "Remove existing GremDesk Server startup shortcut if present?" $false
  if ($remove) { Remove-StartupShortcut }
}

Write-Host "Done."
