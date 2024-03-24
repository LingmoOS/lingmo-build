#!/bin/bash
shopt -s extglob
set -e
script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$script_dir/LingmoSrcBuild/Src
deb_dir=$script_dir/LingmoSrcBuild/Deb

echo '欢迎使用灵墨OS for Arm 自动编译脚本!'
echo '提示: 使用前请确认已经安装了所有必要的依赖。'
echo '因为性能问题，不再编译Kwin'

if test -e $source_dir
then
  echo '存在同名的LingmoOS源文件夹，正在删除...'
  rm -rf $source_dir
fi
echo '创建新的LingmoOS源文件夹...'
mkdir -p $source_dir

if test -e $deb_dir
then
  echo '存在同名的LingmoOS输出文件夹，正在删除...'
  rm -rf $deb_dir
fi
echo '创建新的LingmoOS输出文件夹...'
mkdir -p $deb_dir

function InstallDepends() {
    echo '开始安装依赖'
    apt-get --yes install git  devscripts equivs
    rm -rfv LingmoOSBuildDeps
    git clone https://github.com/LingmoOS/LingmoOSBuildDeps.git
    cd LingmoOSBuildDeps
    mk-build-deps -i -t "apt-get -y" -r  > /dev/null
}

# 定义一个函数来编译项目
function Compile() {
    repo_name=$1
    echo "开始编译 $repo_name ..."
    cd $source_dir
    if test -d $repo_name; then
        echo "已存在 $repo_name 目录，更新中..."
        cd $repo_name && git reset --hard HEAD && git pull
    else
        echo "正在克隆 $repo_name ..."
        git clone https://github.com/LingmoOS/$repo_name.git
        cd $repo_name
    fi
    echo "正在安装 $repo_name 依赖..."
    # 在这里添加项目的依赖安装代码
    mk-build-deps -i -t "apt-get --yes" -r
    echo "构建 $repo_name ..."
    dpkg-buildpackage -b -uc -us -tc -j$(nproc)
    # 在这里添加项目构建和编译命令
    echo "$repo_name 编译完成"

    # lingmo-kwin 需要安装
    if [ "$repo_name" = "lingmo-kwin" ]; then
        echo "安装 lingmo-kwin"
        apt install -y --no-install-recommends $source_dir/!(*dbgsym*).deb
    fi
    
    echo "复制 $repo_name 的安装包"
    cd $source_dir
    mv -v !(*dbgsym*).deb $deb_dir/
}
REPOS="lingmo-screenlocker lingmo-settings lingmo-screenshots lingmo-cursor-themes lingmo-sddm-theme lingmo-appmotor lingmo-neofetch lingmo-daemon lingmo-terminal lingmo-gtk-themes LingmoUI lingmo-systemicons lingmo-wallpapers lingmo-debinstaller lingmo-calculator lingmo-launcher lingmo-statusbar lingmo-dock liblingmo lingmo-filemanager lingmo-core lingmo-texteditor lingmo-videoplayer"

# 先安装依赖
InstallDepends

# 列出所有项目供用户选择
select project in \
lingmo-screenlocker \
lingmo-settings \
lingmo-screenshots \
lingmo-cursor-themes \
lingmo-sddm-theme \
lingmo-appmotor \
lingmo-neofetch \
lingmo-daemon \
lingmo-terminal \
lingmo-gtk-themes \
LingmoUI \
lingmo-systemicons \
lingmo-wallpapers \
lingmo-debinstaller \
lingmo-calculator \
lingmo-launcher \
lingmo-statusbar \
lingmo-dock \
liblingmo \
lingmo-filemanager \
lingmo-core \
lingmo-texteditor \
lingmo-videoplayer \
all \
quit

do
    if [[ $project == "all" ]]; then
        for repo in $REPOS; do
            Compile $repo
        done
        exit 0
    elif [[ $project == "quit" ]]; then
        break
    else
        Compile $project
    fi
done
