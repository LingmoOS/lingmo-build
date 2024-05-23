<#
    .DESCRIPTION
    Ultis for building packages
#>
Import-Module "$PSScriptRoot/GlobalConfig"
Import-Module "$PSScriptRoot/GitModule"
Import-Module "$PSScriptRoot/SourceRepoTools"

function Get-SudoPrivilege {
    Write-Host "Now checking for sudo rights."
    Write-Host "Please enter your password to get sudo right if needed."

    $currentUser = (whoami).ToString()
    if ($currentUser -ne "root") {
        sudo sh -c "echo 1 >> /dev/null"
    }

    $currentUser = (sudo whoami).ToString()
    if ($currentUser -ne "root") {
        return $false
    }

    return $true
}

function Install-GlobalDepends {
    Write-Host "Installing Common build dependencies"

    $Env:LC_ALL="C.UTF-8"

    sudo apt-get --yes install git devscripts equivs | Out-Null

    # Assuming Windows has "LingmoOSBuildDeps" directory support
    $repoPath = Import-LingmoRepo "https://git.lingmo.org/lingmo-os-team/LingmoOSBuildDeps.git" "LingmoOSBuildDeps" 
    Set-Location $repoPath
    sudo mk-build-deps -i -t "apt-get -y" -r | Out-Null
}

function Install-RepoDepends($repoPath) {
    $Env:LC_ALL="C.UTF-8"

    # Assuming Windows has "LingmoOSBuildDeps" directory support
    Set-Location $repoPath
    sudo mk-build-deps -i -t "apt-get -y" -r | Out-Null
}

# 定义一个函数来编译项目
function Start-CompileDeb($repo) {
    Write-Host "Start to compile $($repo.repoName) ..."

    Set-Location $repo.m_repoPath

    Write-Host "Install depends for $($repo.repoName) ..."
    Install-RepoDepends $repo.m_repoPath

    Write-Host "Build $($repo.repoName) ..."
    dpkg-buildpackage -b -uc -us -tc -j"$(nproc)" | Out-Null

    Write-Host "$($repo.repoName) Complete!"

    Write-Host "Copy $($repo.repoName) artifacts"

    # 设置目录路径
    $debPath = Get-SourceCodePath
    # 检查目录是否存在，如果不存在则创建
    if (-not (Test-Path (Get-ArtifactExportPath))) {
        New-Item -ItemType Directory -Path (Get-ArtifactExportPath) | Out-Null
    }
    # 移动符合条件的文件
    Get-ChildItem -Path $debPath -Filter '*.deb' | Move-Item -Force -Confirm:$false -Destination (Get-ArtifactExportPath)
}


function Start-PackageBuild {
    param (
        [System.Array] $configs
    )

    # Checking root
    $isRoot = Get-SudoPrivilege
    if ($isRoot -eq $false) {
        Write-Host "No root privilege, exiting"
        exit 1
    }

    # Install All Depends
    Install-GlobalDepends

    foreach ($conf in $configs) {
        switch ($conf.buildType) {
           "Debian" {
                Start-CompileDeb $conf
           }
        }
    }
}
