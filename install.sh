#!/bin/bash -eu

git_user_name=$(git config --global user.name || echo -n)
git_user_email=$(git config --global user.email || echo -n)

if [[ ! -d $HOME/.ssh ]]; then
  mkdir -p $HOME/.ssh
  chmod 700 $HOME/.ssh
fi

function install-dotfile() {
  cp -v "$1" "${HOME}/.$1" && chmod 644 "${HOME}/.$1"
}

install-dotfile gitconfig
install-dotfile screenrc
install-dotfile vimrc
install-dotfile tmux.conf

install-dotfile profile
mkdir -p $HOME/.profile.d

if [[ ! -e $HOME/.ssh/config ]]; then
  cp -v sshconfig $HOME/.ssh/config
fi

if [[ "x$(uname)" == "xDarwin" ]]; then
  cat screenrc | grep -v deflogin > $HOME/.screenrc
fi

if [[ "x${git_user_name}" == "x" ]]; then
  read -p "Git user name: " git_user_name
fi

if [[ "x${git_user_email}" == "x" ]]; then
  read -p "Git user email: " git_user_email
fi

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"

# Vim colorscheme.
[[ -d $HOME/.vim ]] || git clone https://github.com/nanotech/jellybeans.vim $HOME/.vim

function install-binary() {
  cp -v "bin/$1" "${HOME}/bin" && chmod 755 "${HOME}/bin/$1"
}

mkdir -p $HOME/bin
install-binary ssh-tmux
