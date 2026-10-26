$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$backend = Join-Path $root "backend"
$frontend = Join-Path $root "frontend"
$backendPython = Join-Path $backend "venv\Scripts\python.exe"
$rootPython = Join-Path $root ".venv\Scripts\python.exe"

$python = $backendPython

if (-not (Test-Path $python)) {
  $python = $rootPython
}

if (-not (Test-Path $python)) {
  $python = "python"
}

Write-Host "Starting GeoShield backend on http://localhost:8000 ..."
$backendJob = Start-Job -Name "GeoShield Backend" -ScriptBlock {
  param($backendPath, $pythonPath)
  Set-Location $backendPath
  & $pythonPath -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
} -ArgumentList $backend, $python

for ($i = 0; $i -lt 45; $i++) {
  try {
    Invoke-RestMethod -Uri "http://localhost:8000/health" -TimeoutSec 2 | Out-Null
    Write-Host "Backend is ready."
    break
  } catch {
    Start-Sleep -Seconds 1
  }
}

if ($backendJob.State -ne "Running") {
  Receive-Job $backendJob
  throw "Backend failed to start."
}

Write-Host "Starting GeoShield frontend on http://localhost:3000 ..."
$frontendJob = Start-Job -Name "GeoShield Frontend" -ScriptBlock {
  param($frontendPath)
  Set-Location $frontendPath
  npm run dev
} -ArgumentList $frontend

Write-Host ""
Write-Host "GeoShield is starting:"
Write-Host "  Frontend: http://localhost:3000"
Write-Host "  Backend:  http://localhost:8000"
Write-Host ""
Write-Host "Press Ctrl+C to stop both servers."

try {
  while ($true) {
    Receive-Job $backendJob -Keep
    Receive-Job $frontendJob -Keep

    if ($backendJob.State -ne "Running") {
      throw "Backend stopped unexpectedly."
    }
    if ($frontendJob.State -ne "Running") {
      throw "Frontend stopped unexpectedly."
    }

    Start-Sleep -Seconds 2
  }
} finally {
  Stop-Job $backendJob, $frontendJob -ErrorAction SilentlyContinue
  Remove-Job $backendJob, $frontendJob -Force -ErrorAction SilentlyContinue
}
