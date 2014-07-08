#!/bin/bash -eu

readonly git_user_name=$(git config --global user.name || echo -n)
readonly git_user_email=$(git config --global user.email || echo -n)

if [[ ! -d $HOME/.ssh ]]
then
  mkdir $HOME/.ssh
  chmod 700 $HOME/.ssh
fi

cp -v gitconfig $HOME/.gitconfig
cp -v screenrc $HOME/.screenrc
cp -v vimrc $HOME/.vimrc
cp -v tmux.conf $HOME/.tmux.conf

cp -v profile $HOME/.profile
mkdir -p $HOME/.profile.d

if [[ ! -e $HOME/.ssh/config ]]
then
  cp -v sshconfig $HOME/.ssh/config
fi

if [[ "x$(uname)" == "xDarwin" ]]; then
  cat screenrc | grep -v deflogin > $HOME/.screenrc
fi

if [[ "$git_user_name" == "" ]]; then
  read -p "Git user name: " git_user_name
fi

if [[ "$git_user_email" == "" ]]; then
  read -p "Git user email: " git_user_email
fi

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"

function install-binary() {
  cp -v "bin/$1" "${HOME}/bin" && chmod +x "${HOME}/bin/$1"
}

mkdir -p $HOME/bin
install-binary ssh-tmux
