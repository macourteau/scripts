export PATH=/usr/local/sbin:/usr/local/bin:$HOME/bin:$PATH

readonly darwin=$(expr $(uname -a | grep -i darwin | wc -l))

# Setup an 'l' alias.
if [[ $darwin -ne 0 ]]; then
  # Mac-specific aliases.
  alias l='ls -AlG'
  alias ldd='otool -L'
else
  alias l='ls -Al --color'
fi

alias hd='hexdump -n 128 -C'

# Enable color in grep.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable color in less.
alias less='less -R'
export LESS=FRSX

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "${HOME}/.bashrc" ]; then
    . "${HOME}/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:$PATH"
fi

# Setup the prompt.
if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w$ '
  else
    if [ "$(id -u)" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

# More useful output when tracing with 'set -x'.
export PS4='$0($LINENO): '

export LC_CTYPE=en_US.UTF-8
export EDITOR=vi

# Better control of bash history.
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth:erasedups
shopt -s cmdhist
shopt -s histappend

# Load the ICC compiler vars if it is installed.
if [[ -e /opt/intel/bin/compilervars.sh ]]; then
  . /opt/intel/bin/compilervars.sh intel64
fi

# Tell gyp to generate ninja build files, and if on Mac, Xcode projects as well.
if [[ $darwin -ne 0 ]]; then
  export GYP_GENERATORS="ninja xcode"
else
  export GYP_GENERATORS="ninja"
fi

# Append npm binaries to the path if present.
if [[ -e /usr/local/share/npm/bin ]]; then
  export PATH="$PATH":/usr/local/share/npm/bin
fi

# Setup path for node.js.
if [[ -e /usr/local/lib/node ]]; then
  export NODE_PATH=/usr/local/lib/node
fi

# Setup path for Go.
if [[ -e "${HOME}/gocode" ]]; then
  export GOPATH="${HOME}/gocode"
fi

# Bash completion provided by homebrew (if installed).
command -v brew > /dev/null 2>&1 && if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Add the 'subl' binary to the path if Sublime Text 2 is installed.
if [[ $darwin -ne 0 && -d /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin ]]; then
  export PATH="$PATH":/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin
fi

# TeX.
if [[ -d /usr/texbin ]]; then
  export PATH="$PATH":/usr/texbin
fi

# Source any "local" additions to profile.
if [[ -d "${HOME}/.profile.d" ]]; then
  for x in $(ls "${HOME}/.profile.d"); do
    . "${HOME}/.profile.d/${x}"
  done
fi
