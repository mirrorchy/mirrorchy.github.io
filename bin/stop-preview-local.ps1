$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$pidFile = Join-Path $repoRoot ".tmp\jekyll-preview.pid"

if (-not (Test-Path $pidFile)) {
  Write-Host "No local preview server is running on port 4000." -ForegroundColor Yellow
  exit 0
}

$previewPid = (Get-Content $pidFile -ErrorAction SilentlyContinue | Select-Object -First 1).Trim()

if (-not $previewPid) {
  Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  Write-Host "No local preview server is running on port 4000." -ForegroundColor Yellow
  exit 0
}

$process = Get-Process -Id $previewPid -ErrorAction SilentlyContinue

if (-not $process) {
  Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  Write-Host "No local preview server is running on port 4000." -ForegroundColor Yellow
  exit 0
}

Stop-Process -Id $previewPid -Force
Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
Write-Host "Stopped preview process $previewPid." -ForegroundColor Green
