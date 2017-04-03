#!/bin/bash -eu

INSTALL_PROFILE=1
while (( "$#" )); do
  case "$1" in
    "--no_profile")
      INSTALL_PROFILE=0
      ;;
    *)
      echo "error: unrecognized argument: $1" >&2
      exit 1
  esac
  shift
done

readonly script=$(basename $0)
readonly script_dir=$(dirname $0)

# Save the current git user name/email.
git_user_email=$(git config --global user.email || echo -n)
git_user_name=$(git config --global user.name || echo -n)

# Read-in the variables if they weren't already set.
if [[ "x${git_user_email}" == "x" ]]; then
  read -p "${script}: git user's email: " git_user_email
fi

if [[ "x${git_user_name}" == "x" ]]; then
  read -p "${script}: git user's full name: " git_user_name
fi

# Create the .ssh directory with the right permissions.
if [[ ! -d "${HOME}/.ssh" ]]; then
  mkdir -p "${HOME}/.ssh"
  chmod 700 "${HOME}/.ssh"
fi

# Installs a dotfile to the user's $HOME directory.
function install-dotfile() {
  target="${HOME}/.$1"
  echo -n "${script}: install $1 to \"${target}\"... "
  cp "$1" "${target}"
  chmod 644 "${target}"
  echo "done."
}

function append-to-dotfile() {
  target="${HOME}/.$1"
  echo -n "${script}: append $1 to \"${target}\"... "
  cat "$1" >> "${target}"
  chmod 644 "${target}"
  echo "done."
}

# Installs an executable file to the user's $HOME/bin directory.
function install-binary() {
  target="${HOME}/bin/$1"
  echo -n "${script}: install binary $1 to \"${target}\"... "
  mkdir -p "${HOME}/bin"
  cp "bin/$1" "${target}"
  chmod 755 "${target}"
  echo "done."
}

install-dotfile vimrc
install-dotfile tmux.conf

install-binary ssh-tmux

if [[ ${INSTALL_PROFILE} -eq 1 ]]; then
  install-dotfile profile
  mkdir -p "${HOME}/.profile.d"
fi

# Don't overwrite .ssh/config if it's already there, but otherwise, install our
# custom .ssh/config file.
if [[ ! -e "${HOME}/.ssh/config" ]]; then
  cp -v sshconfig "${HOME}/.ssh/config"
fi

install-dotfile screenrc
if [[ "x$(uname)" == "xDarwin" ]]; then
  # Remove the 'deflogin' line on Mac OS X.
  cat screenrc | grep -v deflogin > "${HOME}/.screenrc"
fi

install-dotfile gitconfig
git config --global user.name "${git_user_name}"
git config --global user.email "${git_user_email}"

install-dotfile gitignore
git config --global core.excludesfile "${HOME}/.gitignore"

if [[ -f "${HOME}/.eaglerc" ]]; then
  python "${script_dir}/install-eaglerc.py"
fi

# Pathogen for vim.
mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/bundle" "${HOME}/.vim/plugin"
curl -LSso "${HOME}/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim

# Solarized color theme for vim.
if [[ ! -e "${HOME}/.vim/bundle/vim-colors-solarized" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/altercation/vim-colors-solarized.git
  popd
fi

# Jellybeans color theme for vim.
if [[ ! -e "${HOME}/.vim/bundle/jellybeans.vim" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/nanotech/jellybeans.vim.git
  popd
fi

# vim-airline status line for vim.
if [[ ! -e "${HOME}/.vim/bundle/vim-airline" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/bling/vim-airline.git
  popd
fi

# vim-fugitive for vim.
if [[ ! -e "${HOME}/.vim/bundle/vim-fugitive" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/tpope/vim-fugitive.git
  popd
fi

# vim-bufferline for vim.
if [[ ! -e "${HOME}/.vim/bundle/vim-bufferline" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/bling/vim-bufferline.git
  popd
fi

# autoclose plugin for vim. Remove if installed.
rm -f ${HOME}/.vim/plugin/autoclose.vim

# auto-pairs for vim.
if [[ ! -e "${HOME}/.vim/bundle/auto-pairs" ]]; then
  pushd "${HOME}/.vim/bundle"
  git clone git://github.com/jiangmiao/auto-pairs.git
  popd
fi
