#!/usr/bin/env pwsh

# Detect Directory
$LingMainScriptPath = $MyInvocation.MyCommand.Definition
$LingMainScriptDirectory  = Split-Path $LingMainScriptPath -Parent

# Import modules
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/GlobalConfig")
Import-Module (Join-Path $LingMainScriptDirectory "/Modules/GitModule")

<#
    .Description
    Main entry for Lingmo DE builder
#>
function Main() {
    Write-Output "Current Root Path: $(Get-LingmoRootPath)"
    Write-Output "Current Artifact Path: $(Get-ArtifactExportPath)"

    $repo_path = (Import-LingmoRepo "https://git.lingmo.org/lingmo-os-team/lingmo-build.git" "lingmo-build")

    echo $repo_path
}


# Enter main function
Main