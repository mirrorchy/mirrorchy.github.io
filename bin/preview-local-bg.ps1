$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$rubyBin = "C:\Ruby34-x64\bin"
$nodeBin = "C:\Program Files\nodejs"
$gitBin = "C:\Program Files\Git\cmd"
$imageMagickBin = "C:\Program Files\ImageMagick-7.1.2-Q16"
$logDir = Join-Path $repoRoot ".tmp"
$stdoutLog = Join-Path $logDir "jekyll-preview.out.log"
$stderrLog = Join-Path $logDir "jekyll-preview.err.log"
$pidFile = Join-Path $logDir "jekyll-preview.pid"

$requiredPaths = @($rubyBin, $nodeBin, $gitBin, $imageMagickBin)
$missingPaths = $requiredPaths | Where-Object { -not (Test-Path $_) }

if ($missingPaths.Count -gt 0) {
  Write-Error "Missing required tools: $($missingPaths -join ', ')"
}

if (-not (Test-Path $logDir)) {
  New-Item -ItemType Directory -Path $logDir | Out-Null
}

$env:Path = ($requiredPaths -join ";") + ";" + $env:Path

if (Test-Path $pidFile) {
  $existingPid = (Get-Content $pidFile -ErrorAction SilentlyContinue | Select-Object -First 1).Trim()
  if ($existingPid) {
    $existingProcess = Get-Process -Id $existingPid -ErrorAction SilentlyContinue
    if ($existingProcess) {
      Write-Host "A local preview server is already running on http://127.0.0.1:4000/ (PID: $existingPid)" -ForegroundColor Yellow
      exit 0
    }
  }
}

$process = Start-Process `
  -FilePath "$rubyBin\bundle.bat" `
  -ArgumentList "exec", "jekyll", "serve", "--host", "127.0.0.1", "--port", "4000", "--livereload" `
  -WorkingDirectory $repoRoot `
  -RedirectStandardOutput $stdoutLog `
  -RedirectStandardError $stderrLog `
  -PassThru

$process.Id | Set-Content -Path $pidFile

Write-Host "Started local preview at http://127.0.0.1:4000/ (PID: $($process.Id))" -ForegroundColor Green
Write-Host "Logs:" -ForegroundColor Green
Write-Host "  $stdoutLog"
Write-Host "  $stderrLog"
