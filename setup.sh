#!/bin/bash

DOTFILES_DIR=`pwd`

DOT_FILES=( .gitconfig .zsh .zshrc .tmux.conf .emacs.d)

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

if [[ ! -e $HOME/.emacs.d/site-lisp/elscreen ]]; then
  git clone https://github.com/tam17aki/elscreen.git $HOME/.emacs.d/site-lisp/elscreen
fi

EMACS_DIR=$HOME/.emacs.d
INITS_DIR=$HOME/inits-local

if [[ ! -e $INITS_DIR ]]; then
  mkdir $INITS_DIR
fi

ln -s $EMACS_DIR/inits/elscreen.el       $INITS_DIR/50_elscreen.el
ln -s $EMACS_DIR/inits/c++-mode.el       $INITS_DIR/50_c++-mode.el
ln -s $EMACS_DIR/inits/yasnippet_init.el $INITS_DIR/50_yasnippet_init.el
ln -s $EMACS_DIR/inits/twitter-init.el   $INITS_DIR/60_twitter.el
ln -s $EMACS_DIR/inits/gtags_init.el     $INITS_DIR/50_gtags.el
