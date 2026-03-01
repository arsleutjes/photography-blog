# Install Lightroom Classic presets from this repository to their correct locations.

$scriptDir = $PSScriptRoot
$presetsRoot = Join-Path $scriptDir "Photography Portfolio"

$exportPresetsSource    = Join-Path $presetsRoot "Export Presets"
$watermarkPresetsSource = Join-Path $presetsRoot "Watermark Presets"

$exportPresetsDest    = Join-Path $env:APPDATA "Adobe\Lightroom\Export Presets\User Presets"
$watermarkPresetsDest = Join-Path $env:APPDATA "Adobe\Lightroom\Watermarks"

function Install-Presets {
    param (
        [string]$Source,
        [string]$Destination,
        [string]$Label
    )

    Write-Host "`n[$Label]"
    Write-Host "  Source : $Source"
    Write-Host "  Dest   : $Destination"

    if (-not (Test-Path $Source)) {
        Write-Warning "  Source folder not found, skipping."
        return
    }

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        Write-Host "  Created destination folder."
    }

    $files = Get-ChildItem -Path $Source -Filter "*.lrtemplate"

    if ($files.Count -eq 0) {
        Write-Warning "  No .lrtemplate files found in source."
        return
    }

    foreach ($file in $files) {
        $dest = Join-Path $Destination $file.Name
        Copy-Item -Path $file.FullName -Destination $dest -Force
        Write-Host "  Copied: $($file.Name)"
    }
}

Install-Presets -Source $exportPresetsSource    -Destination $exportPresetsDest    -Label "Export Presets"
Install-Presets -Source $watermarkPresetsSource -Destination $watermarkPresetsDest -Label "Watermark Presets"

Write-Host "`nDone. Restart Lightroom Classic for the presets to appear."
