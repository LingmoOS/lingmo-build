<#
    .DESCRIPTION
    Contain helpers for using git.
#>

Import-Module "$PSScriptRoot/GlobalConfig"
Import-Module "$PSScriptRoot/CommonUtils"

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
        [bool] $cloneDevGit,
        [Parameter()]
        [string] $Tag
    )

    $cloneDst = "$(Get-SourceCodePath)/$saveName"

    Remove-DirIfExist $cloneDst

    if ($cloneDevGit -eq $true) {
        $params = @("clone", "$($repoURL)", "$($cloneDst)")
        $ret = Start-ShellProcess "git" $params
    } else {
        $params = @("clone", "-b", "$($Tag)", "$($repoURL)", "$($cloneDst)")
        $ret = Start-ShellProcess "git" $params
    }

    return $cloneDst
}
Export-ModuleMember -Function Import-LingmoRepo
