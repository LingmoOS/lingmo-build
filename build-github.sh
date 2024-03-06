#!/bin/bash
set -e

echo '欢迎使用灵墨OS自动编译脚本!'
echo '提示: 使用前请确认已经安装了所有必要的依赖。'

if test -e ~/LingmoOS
then
  echo '存在同名的LingmoOS文件夹，正在删除...'
  sudo rm -rf ~/LingmoOS
fi
echo '创建新的LingmoOS文件夹...'
mkdir ~/LingmoOS

# 定义一个函数来编译项目
function Compile() {
    repo_name=$1
    echo "开始编译 $repo_name ..."
    cd ~/LingmoOS
    if test -d $repo_name; then
        echo "已存在 $repo_name 目录，更新中..."
        cd $repo_name && git pull
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
}

echo '开始安装依赖'
sudo apt install libpolkit-qt5-1-dev qml-module-qtquick-dialogs libxcb-damage0-dev libicu-dev libqapt-dev libkf5solid-dev pkg-config extra-cmake-modules libpam0g-dev libxcb-util-dev lintian libsm-dev libkf5screen-dev libxcb-composite0-dev qml-module-qt-labs-settings libqt5sensors5-dev libcanberra-dev qml-module-qtqml debhelper libfreetype6-dev libkf5bluezqt-dev qml-module-qtquick-shapes libapt-pkg-dev xserver-xorg-dev qtbase5-dev libx11-dev libcrypt-dev libfontconfig1-dev cmake qml-module-qtquick-particles2 libxcb1-dev xserver-xorg-input-synaptics-dev libkf5idletime-dev libkf5networkmanagerqt-dev automake libqt5x11extras5-dev git libxcb-dri2-0-dev qml-module-qtquick2 libxcursor-dev qttools5-dev qml-module-qtquick-layouts libcanberra-pulse libxcb-keysyms1-dev libsystemd-dev gcc -y libxcb-glx0-dev qttools5-dev-tools qml-module-qtquick-window2 libxcb-image0-dev libcap-dev libpulse-dev libxcb-randr0-dev qml-module-qtquick-controls2 libxcb-shm0-dev libxcb-ewmh-dev equivs libxcb-icccm4-dev qtdeclarative5-dev libkf5kio-dev qtquickcontrols2-5-dev libkf5coreaddons-dev devscripts libxcb-xfixes0-dev libxcb-record0-dev qml-module-qt-labs-platform libxtst-dev libxcb-dpms0-dev build-essential libkf5windowsystem-dev xserver-xorg-input-libinput-dev autotools-dev libx11-xcb-dev libxcb-dri3-dev qml-module-org-kde-kwindowsystem libkf5globalaccel-dev qtbase5-private-dev modemmanager-qt-dev libpolkit-agent-1-dev curl libxcb-shape0-dev --no-install-recommends -y

REPOS="lingmo-screenlocker lingmo-settings lingmo-screenshots lingmo-cursor-themes lingmo-sddm-theme lingmo-appmotor lingmo-neofetch lingmo-daemon lingmo-ocr lingmo-terminal lingmo-gtk-themes LingmoUI lingmo-systemicons lingmo-wallpapers lingmo-debinstaller lingmo-calculator lingmo-system-build lingmo-windows-plugins lingmo-launcher lingmo-kwin lingmo-kernel lingmo-statusbar lingmo-qt-plugins lingmo-dock lingmo-system-core liblingmo lingmo-filemanager lingmo-core lingmo-texteditor lingmo-kwin-plugins lingmo-videoplayer"

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
lingmo-ocr \
lingmo-terminal \
lingmo-gtk-themes \
LingmoUI \
lingmo-systemicons \
lingmo-wallpapers \
lingmo-debinstaller \
lingmo-calculator \
lingmo-system-build \
lingmo-windows-plugins \
lingmo-launcher \
lingmo-kwin \
lingmo-kernel \
lingmo-statusbar \
lingmo-qt-plugins \
lingmo-dock \
lingmo-system-core \
liblingmo \
lingmo-filemanager \
lingmo-core \
lingmo-texteditor \
lingmo-kwin-plugins \
lingmo-videoplayer \
all \
quit

do
    if [[ $project == "all" ]]; then
        for repo in $REPOS; do
            Compile $repo
        done
    elif [[ $project == "quit" ]]; then
        break
    else
        Compile $project
    fi
done
