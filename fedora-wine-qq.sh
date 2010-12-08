#/usr/bin/env bash



ttc=( $(find /usr/share/fonts -name 'simsun.ttc') )

if [[ ${ttc} == "" ]]
then
    if [[ -e ~/.fonts/simsun.ttc ]]
    then
	ttc="~/.fonts/simsun.ttc"
    else
	cat >&2 <<EOF
Error: cannot find simsun.ttc on your system, please put simsun.ttc under ~/.fonts and run this script again.
EOF
    fi
    
fi



# make sure wine is installed
wine32=$(yum info wine.i686 | grep -Po '(?<=^Repo).*' | grep -Po '\w+$')
wine64=$(yum info wine.x86_64 | grep -Po '(?<=^Repo).*' | grep -Po '\w+$')

if [[ ${wine32} != 'installed' && ${wine64} != 'installed' ]] 
then
    su -c 'yum -y install wine.i686'
    if [[ $? != 0 ]]
    then
	echo 'Error: failed to install wine!' >&2
	exit 1
    fi
fi

if [[ ${wine64} == 'installed' ]]
then
    cat >&2 << EOF
Warning: It is highly recommended to run QQ with wine.i686, anyway we will move on.
EOF
fi

# make sure winetricks is installed

if [[ $(which winetricks) == "" ]]
then
    mkdir -p ~/bin
    wget -P ~/bin http://www.kegel.com/wine/winetricks
    chmod u+x ~/bin/winetricks
fi


export WINEPREFIX=~/.wine_qq
export WINEARCH=win32

if [[ -e ${WINEPREFIX} ]]
then
    cat >&2 <<EOF
    Error:  ~/.wine_qq already exists!
EOF
    exit 1
fi

. $(which winetricks) -q


load_fakesimsun() {
    cat > "$WINETRICKS_TMP"/fakesimsun.reg <<_EOF_
REGEDIT4

[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
"MS Shell Dlg 2"="SimSun"
"Tahoma"="SimSun"

_EOF_

   try_regedit "$WINETRICKS_TMP_WIN"\\fakesimsun.reg
}

mkdir -p "$WINETRICKS_TMP"

load_gdiplus
load_flash
load_ie6
load_msxml3
load_riched20
load_riched30
load_vcrun6
load_vcrun2005
load_fakesimsun

rm -rf "$WINETRICKS_TMP"

ln -s "${ttc}" "${WINEPREFIX}/drive_c/windows/Fonts/simsun.ttc"

# install qq
download . http://softdl1.tech.qq.com/soft/21/QQ2009_chs.exe
try ${WINE} "${WINETRICKS_CACHE}"/"QQ2009_chs.exe"

# after installation
cp ${WINEPREFIX}/drive_c/Program\ Files/Tencent/QQ/Bin/tssafeedit.dat ${WINEPREFIX}/drive_c/Program\ Files/Tencent/QQ/Bin/tssafeedit.dat.backup
mv ${WINEPREFIX}/drive_c/Program\ Files/Tencent/QQ/Bin/auclt.exe ${WINEPREFIX}/drive_c/Program\ Files/Tencent/QQ/Bin/auclt.exe.backup

cat >~/bin/QQ <<EOF
#!/usr/bin/env bash
export WINEPREFIX=${WINEPREFIX}
cd ${WINEPREFIX}/drive_c/Program\ Files/Tencent/QQ/Bin
rm -f tssafeedit.dat
cp tssafeedit.dat.backup tssafeedit.dat
wine QQ.exe
EOF
chmod u+x ~/bin/QQ


