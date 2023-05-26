#!/bin/bash 

DOTFILES=`pwd`
cd $HOME

sudo apt-get install -y zsh tmux xsel curl

# oh-my-zsh
if [ ! -e $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    mv $HOME/.zshrc $HOME/.zshrc.oh-my-zsh.orig
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zaw.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zaw
fi

# starship
curl https://starship.rs/install.sh -fsSL | sh -s -- -y

./setup.sh
