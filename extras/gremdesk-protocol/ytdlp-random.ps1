param(
    [Parameter(Mandatory = $true)]
    [string]$Url,

    [string]$YtDlpDirectory = 'C:\Gremster\yt-dlp',
    [string]$OutputDirectory = 'C:\Gremster\yt-dlp\outputs\testing'
)

$ErrorActionPreference = 'Stop'

$ytDlpPath = Join-Path $YtDlpDirectory 'yt-dlp.exe'
$configPath = Join-Path $YtDlpDirectory 'yt-dlp.conf'

if (-not (Test-Path -LiteralPath $ytDlpPath -PathType Leaf)) {
    throw "yt-dlp executable not found: $ytDlpPath"
}

if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw "yt-dlp config not found: $configPath"
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$randomName = [guid]::NewGuid().ToString('N').Substring(0, 8)
$outputTemplate = Join-Path $OutputDirectory "$randomName.%(ext)s"

Write-Host "Saving as $outputTemplate"

Push-Location $YtDlpDirectory
try {
    & $ytDlpPath --config-location $configPath -o $outputTemplate $Url
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}
