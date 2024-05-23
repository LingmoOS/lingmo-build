<#
    .DESCRIPTION
    Global Vars will be defined in this file
#>

function Get-LingmoRootPath () {
    $LingMainScriptDirectory  = Split-Path $PSScriptRoot -Parent
    return $LingMainScriptDirectory
}
Export-ModuleMember -Function Get-LingmoRootPath

function Get-ArtifactExportPath () {
    return (Join-Path (Get-LingmoRootPath) "/BuildArtifacts")
}
Export-ModuleMember -Function Get-ArtifactExportPath

function Get-SourceCodePath () {
    return (Join-Path (Get-LingmoRootPath) "/LingmoSourceCodes")
}
Export-ModuleMember -Function Get-SourceCodePath

function Get-ConfigPath () {
    return (Join-Path (Get-LingmoRootPath) "/Configs")
}
Export-ModuleMember -Function Get-ConfigPath
