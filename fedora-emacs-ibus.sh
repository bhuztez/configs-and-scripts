#!/usr/bin/env bash

# make sure emacs-ibus is installed
repo=$(yum info emacs-ibus | grep -Po '(?<=^Repo).*' | grep -Po '\w+$')

if [[ ${repo} != 'installed' ]]
then
    su -c 'yum -y install emacs-ibus'
    if [[ $? != 0 ]]
    then
	echo 'Error: failed to install emacs-ibus!' >&2
	exit 1
    fi
fi


xim=$(cat ~/.Xresources | grep 'Emacs\*useXIM')
if [[ ${xim} != "" ]]
then
    cat >&2 << EOF
Error: you have already configured Emacs*useXIM in ~/.Xresources
EOF
    exit 1
fi


cat << EOF >> ~/.Xresources
Emacs*useXIM: false
EOF

