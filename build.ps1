#!/usr/bin/env pwsh

# Detect Directory
$LingMainScriptPath = $MyInvocation.MyCommand.Definition
$LingMainScriptDirectory  = Split-Path $LingMainScriptPath -Parent

# Import modules
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/GlobalConfig")

<#
    .Description
    Main entry for Lingmo DE builder
#>
function Main() {
    Write-Output "Current Root Path: " (Get-LingmoRootPath)
    Write-Output "Current Artifact Path: " (Get-ArtifactExportPath)
}


# Enter main function
Main