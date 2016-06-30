#!/usr/bin/zsh

readonly dir="$1"
cd $dir
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
LANG=en_US.UTF-8 vcs_info
echo $vcs_info_msg_0_
