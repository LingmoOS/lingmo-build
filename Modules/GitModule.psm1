<#
    .DESCRIPTION
    Contain helpers for using git.
#>

Import-Module "$PSScriptRoot/GlobalConfig"

<#
    .DESCRIPTION
    Remove the Dir if it exists
#>
function Remove-DirIfExist {
    param (
        [Parameter(Mandatory)]
        [string] $dirPath
    )

    # Check if dir exists
    if (Test-Path -Path $dirPath) {
        Remove-Item $dirPath -Recurse -Force
    }
}

<#
    .DESCRIPTION
    Clone repo into given directory
    .OUTPUTS
    Path to the cloned repo
#>
function Import-LingmoRepo {  
    param (
        [Parameter(Mandatory)]
        [string] $repoURL,
        [Parameter(Mandatory)]
        [string] $saveName,
        [Parameter(Mandatory)]
        [string] $cloneDevGit,
        [Parameter()]
        [string] $Tag
    )

    $cloneDst = "$(Get-SourceCodePath)/$saveName"

    Remove-DirIfExist $cloneDst

    if ($cloneDevGit -eq $true) {
        git clone $repoURL $cloneDst | Out-Null
    } else {
        git clone -b $Tag $repoURL $cloneDst | Out-Null
    }

    return $cloneDst
}
Export-ModuleMember -Function Import-LingmoRepo
