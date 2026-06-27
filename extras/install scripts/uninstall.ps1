# extras\uninstall.ps1
# GremDesk uninstall helper (per-user, no admin)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Remove-ProtocolPerUser() {
    $base = "HKCU:\Software\Classes\gremdesk"

    if (Test-Path $base) {
        Remove-Item -Path $base -Recurse -Force
        Write-Host "Removed gremdesk:// protocol registration."
    } else {
        Write-Host "No gremdesk:// protocol registration found."
    }
}

function Remove-StartupShortcut() {
    $startupDir = [Environment]::GetFolderPath("Startup")
    if ([string]::IsNullOrWhiteSpace($startupDir)) {
        throw "Could not resolve Startup folder."
    }

    $shortcutPath = Join-Path $startupDir "GremDesk Server.lnk"

    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "Removed startup shortcut."
    } else {
        Write-Host "No startup shortcut found."
    }
}

Write-Host "Uninstalling GremDesk components (per-user)..."
Write-Host ""

Remove-ProtocolPerUser
Remove-StartupShortcut

Write-Host ""
Write-Host "Done."
