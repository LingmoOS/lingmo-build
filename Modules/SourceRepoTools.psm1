<#
    .DESCRIPTION
    Contains helpers to read and config source repos
#>

Import-Module "$PSScriptRoot/GitModule"

class SourceItem {
    [string] $repoName

    [string] $repoURL

    [string] $buildType
    
    # Is this repo initialized? i.e. cloned and other init actions.
    [bool] $m_cloned;

    [string] $m_repoPath;

    # Default constructor
    SourceItem() { $this.Init(@{}) }

    # Common constructor
    SourceItem([string]$repoName_, [string]$repoURL_, [string]$buildType_ ) {
        $this.Init(@{
            repoName = $repoName_
            repoURL = $repoURL_
            buildType = $buildType_
        })
    }

    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }

    [bool] CloneRepo() {
        try {
            $this.m_repoPath = (Import-LingmoRepo $this.repoURL $this.repoName)
        } catch {
            Write-Output "An error occurred when cloning repo $($this.repoName):"
            Write-Output $_

            $this.m_cloned = $false
            return $false
        }

        $this.m_cloned = $true
        return $true
    }
}

function Get-ConfigFromFile {
    param (
        [Parameter(Mandatory)]
        [string] $filePath
    )

    $json_data = Get-Content -Raw -Path $filePath | ConvertFrom-Json

    $source_item = [SourceItem]::new(
        $json_data.Name,
        $json_data.Repository,
        $json_data.BuildType
    );

    return $source_item
}
Export-ModuleMember -Function Get-ConfigFromFile

<#
    .DESCRIPTION
    Read all configs in the given dir
    .OUTPUTS
    An array of SourceItem.
#>
function Get-AllRepoConfigs {
    param (
        [string] $configDir,
        [bool] $clone
    )
    
    $configFileNames = (Get-ChildItem (Get-ConfigPath)).Name

    [SourceItem[]] $results;

    foreach ($name in $configFileNames) {
        $fullPath = "$(Get-ConfigPath)/$name"
        $item = Get-ConfigFromFile $fullPath
        if ($clone) {
            $ret = $item.CloneRepo()
        }
        $results += $item
    }

    return $results
}
Export-ModuleMember -Function Get-AllRepoConfigs

