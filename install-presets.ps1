# Install Lightroom Classic presets from this repository to their correct locations.

$scriptDir = $PSScriptRoot

$exportPresetsSourceRoot    = Join-Path $scriptDir "Export Presets"
$watermarkPresetsSourceRoot = Join-Path $scriptDir "Watermark Presets"

$exportPresetsDestRoot    = Join-Path $env:APPDATA "Adobe\Lightroom\Export Presets\User Presets"
$watermarkPresetsDestRoot = Join-Path $env:APPDATA "Adobe\Lightroom\Watermarks"

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
    } else {
        $old = Get-ChildItem -Path $Destination -Filter "*.lrtemplate"
        foreach ($f in $old) {
            Remove-Item $f.FullName -Force
            Write-Host "  Removed: $($f.Name)"
        }
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

    # Copy any image files (e.g. logos) alongside the presets
    $images = Get-ChildItem -Path "$Source\*" -Include "*.png","*.jpg","*.jpeg","*.svg" -File
    foreach ($img in $images) {
        $dest = Join-Path $Destination $img.Name
        Copy-Item -Path $img.FullName -Destination $dest -Force
        Write-Host "  Copied: $($img.Name)"
    }

    # Replace {{LOGO_PATH}} placeholder in copied lrtemplate files with the absolute image path
    foreach ($file in Get-ChildItem -Path $Destination -Filter "*.lrtemplate") {
        $text = [System.IO.File]::ReadAllText($file.FullName)
        if ($text -match '\{\{LOGO_PATH\}\}') {
            # Find the first image in the destination to use as the logo path
            $logoFile = Get-ChildItem -Path "$Destination\*" -Include "*.png","*.jpg","*.jpeg","*.svg" -File | Select-Object -First 1
            if ($logoFile) {
                $escapedPath = $logoFile.FullName -replace '\\', '\\\\'
                $text = $text -replace '\{\{LOGO_PATH\}\}', $escapedPath
                [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.UTF8Encoding]::new($false))
                Write-Host "  Resolved: $($file.Name) -> $($logoFile.FullName)"
            }
        }
    }
}

# Install each subfolder (e.g. Photography Portfolio, SBN) as a separate preset group
foreach ($group in Get-ChildItem -Path $exportPresetsSourceRoot -Directory) {
    $dest = Join-Path $exportPresetsDestRoot $group.Name
    Install-Presets -Source $group.FullName -Destination $dest -Label "Export Presets\$($group.Name)"
}

foreach ($group in Get-ChildItem -Path $watermarkPresetsSourceRoot -Directory) {
    $dest = Join-Path $watermarkPresetsDestRoot $group.Name
    Install-Presets -Source $group.FullName -Destination $dest -Label "Watermark Presets\$($group.Name)"
}

Write-Host "`nDone. Restart Lightroom Classic for the presets to appear."
