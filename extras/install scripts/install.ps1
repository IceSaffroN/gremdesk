# extras\install.ps1
# GremDesk install helper (portable, per-user, no admin)
# Optional components (prompted):
# - Register gremdesk:// protocol (HKCU)
# - Auto-start server at login (Startup folder shortcut)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

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
    if (Test-Path (Join-Path $cur ".git"))       { return $cur }

    $parent = Split-Path $cur -Parent
    if ($parent -eq $cur) {
      throw "Could not find repo root (index.html, README.md, or .git). StartDir=$startDir"
    }
    $cur = $parent
  }
}

function Register-ProtocolPerUser([string]$protoVbsPath) {
  if (!(Test-Path -LiteralPath $protoVbsPath)) {
    throw "Missing protocol VBS: $protoVbsPath"
  }
  $protoVbsPath = (Resolve-Path $protoVbsPath).Path
  if (!(Test-Path -LiteralPath $protoVbsPath)) { throw "Missing protocol VBS: $protoVbsPath" }

  # Per-user protocol registration (no admin). Writes under HKCU:\Software\Classes (merged into HKCR view).
  $base = "HKCU:\Software\Classes\gremdesk"
  New-Item -Path $base -Force | Out-Null
  New-ItemProperty -Path $base -Name "(Default)" -Value "URL:GremDesk Protocol" -Force | Out-Null
  New-ItemProperty -Path $base -Name "URL Protocol" -Value "" -Force | Out-Null

  $cmdKey = Join-Path $base "shell\open\command"
  New-Item -Path $cmdKey -Force | Out-Null

  $wscript = Join-Path $env:WINDIR "System32\wscript.exe"
  $command = '"' + $wscript + '" "' + $protoVbsPath + '" "%1"'

  New-ItemProperty -Path $cmdKey -Name "(Default)" -Value $command -Force | Out-Null
  Write-Host "Registered gremdesk:// protocol (per-user)."
}

function Install-StartupShortcut([string]$repoRoot) {
  $launcher = Join-Path $repoRoot "extras\gremdesk-server\LaunchGremDeskServer.vbs"
  if (!(Test-Path -LiteralPath $launcher)) { throw "Missing server launcher: $launcher" }

  $startupDir = [Environment]::GetFolderPath("Startup")
  if ([string]::IsNullOrWhiteSpace($startupDir)) { throw "Could not resolve current user's Startup folder." }

  $shortcutPath = Join-Path $startupDir "GremDesk Server.lnk"
  if (Test-Path -LiteralPath $shortcutPath) {
    Remove-Item -LiteralPath $shortcutPath -Force
  }

  $wscript = Join-Path $env:WINDIR "System32\wscript.exe"

  $ws = New-Object -ComObject WScript.Shell
  $sc = $ws.CreateShortcut($shortcutPath)
  $sc.TargetPath = $wscript
  $sc.Arguments  = "`"$launcher`""
  $sc.WorkingDirectory = $repoRoot
  $sc.IconLocation = "$wscript,0"
  $sc.Save()

  Write-Host "Installed startup shortcut: $shortcutPath"
}

# ---- main ----

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot  = Get-RepoRoot $scriptDir

Write-Host "Repo root: $repoRoot"

$doProto   = Prompt-YesNo "Install gremdesk:// protocol handler?" $true
$doStartup = Prompt-YesNo "Install auto-start for server at login?" $true

if ($doProto) {
  $protoVbs = Join-Path $repoRoot "extras\gremdesk-protocol\gremdesk.protocol.vbs"
  Register-ProtocolPerUser $protoVbs
}

if ($doStartup) {
  Install-StartupShortcut $repoRoot
}

Write-Host ""
Write-Host "Done."
Write-Host ""
Write-Host "FYI: If you want GremDesk to launch yt-dlp tools, you'll need yt-dlp installed separately."
Write-Host " - Install guide: https://github.com/yt-dlp/yt-dlp#installation"
Write-Host " - Windows options search: https://www.google.com/search?q=yt-dlp+windows+install"
