param(
  [Parameter(Mandatory = $true)]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [string]$Name
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$sourcePath = Join-Path $root $Source
$deliveryDir = Join-Path $root "deliveries"
$zipPath = Join-Path $deliveryDir "$Name.zip"

if (-not (Test-Path $sourcePath)) {
  throw "Source folder not found: $sourcePath"
}

New-Item -ItemType Directory -Force -Path $deliveryDir | Out-Null
if (Test-Path $zipPath) {
  Remove-Item $zipPath -Force
}

Compress-Archive -Path (Join-Path $sourcePath "*") -DestinationPath $zipPath -Force
Write-Output $zipPath
