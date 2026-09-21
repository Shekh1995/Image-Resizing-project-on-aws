$ErrorActionPreference = "Stop"

$buildRoot = Join-Path $PSScriptRoot "build"
$packageRoot = Join-Path $buildRoot "package"
$sourceArchive = Join-Path $PSScriptRoot "CreateThumbnail.zip"
$outputArchive = Join-Path $buildRoot "CreateThumbnail.zip"

Remove-Item $buildRoot -Recurse -Force -ErrorAction SilentlyContinue
New-Item $packageRoot -ItemType Directory -Force | Out-Null

Expand-Archive -Path $sourceArchive -DestinationPath $packageRoot
python -m pip install Pillow --target $packageRoot --platform manylinux2014_x86_64 --implementation cp --python-version 39 --only-binary=:all: --upgrade

Compress-Archive -Path (Join-Path $packageRoot "*") -DestinationPath $outputArchive -CompressionLevel Fastest
Write-Host "Created $outputArchive"