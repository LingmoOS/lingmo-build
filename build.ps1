#!/usr/bin/env pwsh

# Handle cmd params
param(
    [Parameter()]
    [Switch]$BuildFromGit = $false  # Enable this will build from latest git repo instead of latest release.
)

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
    Write-Host "Get and download repo from config files"
    $configList = Get-AllRepoConfigs "$(Get-ConfigPath)" $true $BuildFromGit

    Start-PackageBuild $configList
}


# Enter main function
Main