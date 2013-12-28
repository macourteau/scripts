#!/bin/bash -e

cp -v gitconfig ~/.gitconfig
cp -v profile ~/.profile
cp -v screenrc ~/.screenrc
cp -v vimrc ~/.screenrc

read -p "Git user name: " git_user_name
read -p "Git user email: " git_user_email

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
