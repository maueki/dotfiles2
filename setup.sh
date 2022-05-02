#!/bin/bash

DOTFILES_DIR=`pwd`

DOT_FILES=( .zsh .zshrc .tmux.conf .emacs.d .ctags .globalrc .zprofile )

for file in ${DOT_FILES[@]}
do
    if [ -d $DOTFILES_DIR/$file ]; then
        ln -s $DOTFILES_DIR/$file $HOME
    else
        ln -s $DOTFILES_DIR/$file $HOME/$file
    fi
done

if [[ ! -e $HOME/.zsh/zaw ]]; then
  git clone https://github.com/zsh-users/zaw.git $HOME/.zsh/zaw
fi
