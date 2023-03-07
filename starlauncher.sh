#!/bin/sh

# Check if starlaucnher dir is set
if [ -z ${STARL_DIR+x} ]
then
    echo "Please set STARL_DIR"
    exit 0
else
    echo "STARL_DIR: $STARL_DIR"
fi

# Check if wine is set
# Check if starlaucnher dir is set
if [ -z ${STARL_WINE+x} ]
then
    echo "Please set STARL_WINE"
    exit 0
else
    echo "STARL_WINE: $STARL_WINE"
    $STARL_WINE/wine --version
    read -t 2 -p ""
fi

# Utilities
function title() {
    clear
    echo [===] \>\>\> Star Launcher \>\>\> [===]
}

function setWine() {
    echo [===] Setting ENV [===]
    unset WINEPREFIX
    unset WINEARCH
    unset WINEPATH
    echo
    export WINEPREFIX=$SEBSN_DIR/$1/prefix
    export WINEPATH=$SEBSN_DIR/$1
    export WINEARCH=win64
    #export DXVK_HUD=1
}

function dxvk_check() {
    if [ -d "./dxvk-2.1/" ]
    then
        echo DXVK Installed
    else
        echo Installing DXKV...
        curl -O https://github.com/doitsujin/dxvk/releases/download/v2.1/dxvk-2.1.tar.gz
        tar -xf ./dxvk-2.1.tar.gz
        rm ./dxvk-2.1.tar.gz
    fi
}

# Games
function run_warthunder() {
    $STARL_WINE/wine "$WINEPREFIX/drive_c/users/sebsn/AppData/Local/WarThunder/launcher.exe"
}

function install_warthunder() {
    echo Installing Warthunder..
    read -t 1 -p ""
    mkdir -p $WINEPREFIX

    dxvk_check

    echo [===] Wine Init [===]
    $STARL_WINE/wineboot -u
    sh winetricks arial

    echo [===] DVKK [===]
    cp ./dxvk-2.1/x64/*.dll $WINEPREFIX/drive_c/windows/system32
    cp ./dxvk-2.1/x32/*.dll $WINEPREFIX/drive_c/windows/syswow64
    $STARL_WINE/winecfg

    $STARL_WINE/wine wt_launcher_1.0.3.364.exe
}

# Main
title
dxvk_check
echo "Please select a game"
echo "  1. War Thunder"
read -p ': ' game

if [ $game = "1" ]
then
    setWine "sebs-wt"
    if [ -d $WINEPREFIX ]
    then
        run_warthunder
    else
        install_warthunder
    fi
fi
