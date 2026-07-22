$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$rubyBin = "C:\Ruby34-x64\bin"
$nodeBin = "C:\Program Files\nodejs"
$gitBin = "C:\Program Files\Git\cmd"
$imageMagickBin = "C:\Program Files\ImageMagick-7.1.2-Q16"

$requiredPaths = @($rubyBin, $nodeBin, $gitBin, $imageMagickBin)
$missingPaths = $requiredPaths | Where-Object { -not (Test-Path $_) }

if ($missingPaths.Count -gt 0) {
  Write-Error "Missing required tools: $($missingPaths -join ', ')"
}

$env:Path = ($requiredPaths -join ";") + ";" + $env:Path

Set-Location $repoRoot

Write-Host "Starting local preview at http://127.0.0.1:4000/" -ForegroundColor Green
& "$rubyBin\bundle.bat" exec jekyll serve --host 127.0.0.1 --port 4000 --livereload
