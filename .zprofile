#!/bin/zsh

if [ -e $HOME/.profile ]; then
    emulate sh
    . $HOME/.profile
    emulate zsh
fi
