#!/usr/bin/env pwsh

# Set params
## Stop on error
$ErrorActionPreference = "Stop"

# Detect Directory
$LingMainScriptPath = $MyInvocation.MyCommand.Definition
$LingMainScriptDirectory  = Split-Path $LingMainScriptPath -Parent

# Import modules
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/GlobalConfig")
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/GitModule")
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/SourceRepoTools")
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/BuildUtils")

<#
    .Description
    Main entry for Lingmo DE builder
#>
function Main {
    Write-Host "Current Root Path: $(Get-LingmoRootPath)"
    Write-Host "Current Artifact Path: $(Get-ArtifactExportPath)"

    # Get config list
    Write-Host "Get and download repo fron config files"
    $configList = Get-AllRepoConfigs "$(Get-ConfigPath)" $true

    Start-PackageBuild $configList
}


# Enter main function
Main