<#
    .DESCRIPTION
    Contain helpers for using git.
#>

Import-Module ./GlobalConfig


function Import-LingmoRepo {  
    param (
        [string[]]$repoURL,
        [string[]]$saveName
    )

    $cloneDst = (Get-SourceCodePath)

    git clone $repoURL "$cloneDst/$saveName"
}
Export-ModuleMember -Function Import-LingmoRepo
