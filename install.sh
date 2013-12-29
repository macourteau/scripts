#!/bin/bash -e

git_user_name=$(git config --global user.name || echo -n)
git_user_email=$(git config --global user.email || echo -n)

cp -v gitconfig ~/.gitconfig
cp -v profile ~/.profile
cp -v screenrc ~/.screenrc
cp -v vimrc ~/.vimrc

if [[ "$git_user_name" == "" ]]; then
  read -p "Git user name: " git_user_name
fi

if [[ "$git_user_email" == "" ]]; then
  read -p "Git user email: " git_user_email
fi

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
