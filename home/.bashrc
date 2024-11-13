# local environment changes which should also be available in
# non-interactive sessions
if [ -f ~/.bash_env ]; then
    source ~/.bash_env
fi

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
use_color=false
safe_term=${TERM//[^[:alnum:]]/.}   # sanitize TERM

# source user file if present
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi

if [[ -f /etc/DIR_COLORS ]] ; then
    grep -q "^TERM ${safe_term}" /etc/DIR_COLORS && use_color=true
elif type -p dircolors >/dev/null ; then
    if dircolors --print-database | grep -q "^TERM ${safe_term}" ; then
        use_color=true
    fi
fi

# manual hack for specific terminals
if [ "$TERM" == 'xterm-termite' ]; then
    use_color=true
fi
if [ "$TERM" == 'xterm-256color' ]; then
    use_color=true
fi

if ${use_color} ; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
        PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi
else
    if [[ ${EUID} == 0 ]] ; then
        # show root@ when we don't have colors
        PS1='\u@\h \W \$ '
    else
        PS1='\u@\h \w \$ '
    fi
fi

# display if in a schroot
if [ -n "${SCHROOT_CHROOT_NAME}" ]
then
    PS1="(${SCHROOT_CHROOT_NAME})$PS1"
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term

# useful aliases
if uname -a | grep -i darwin > /dev/null 2> /dev/null; then
    alias ls="ls -h -G"
else
    alias ls="ls -h --color"
fi
alias ll="ls -l"
alias la="ls -a"

if [ -f /proc/cpuinfo ]; then
    alias makej="make -j $(cat /proc/cpuinfo | grep processor | wc | sed -r 's/^ +([0-9])+.*/\1/')"
else
    alias makej="make -j $(sysctl hw.ncpu | awk '{print $2}')"
fi

# general settings
umask 007
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# generic environment variables
if command -v nvim 2> /dev/null > /dev/null; then
    export EDITOR=nvim
    alias vim=nvim
else
    export EDITOR=vim
fi
export VISUAL=$EDITOR

# some more color support
alias grep='grep --color=auto'

man() {
    env \
        LESS_TERMCAP_mb="$(printf "\e[1;37m")" \
        LESS_TERMCAP_md="$(printf "\e[1;37m")" \
        LESS_TERMCAP_me="$(printf "\e[0m")" \
        LESS_TERMCAP_se="$(printf "\e[0m")" \
        LESS_TERMCAP_so="$(printf "\e[1;47;30m")" \
        LESS_TERMCAP_ue="$(printf "\e[0m")" \
        LESS_TERMCAP_us="$(printf "\e[0;36m")" \
        man "$@"
}

# additional commands
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fi

# GPG settings
GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null

# SSH agent settings
if [ -z ${SSH_AUTH_SOCK+x} ]
then
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK
fi

# some common paths
if command -v ruby > /dev/null; then
    if test -d "$(ruby -e "puts Gem.user_dir")/bin"; then
        PATH="$(ruby -e "puts Gem.user_dir")/bin:$PATH"
        export PATH
    fi
fi
if [ -d ~/local/bin ]; then
    export PATH="$HOME/local/bin:$PATH"
fi
if [ -d ~/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
if [ -d ~/.cargo/bin ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d ~/.npm/bin ]; then
    export PATH="$HOME/.npm/bin:$PATH"
fi

alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion -o filenames dquilt

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1
then
    eval "$(pyenv init -)"
fi

# br
if [ -f "${HOME}/.config/broot/launcher/bash/br" ]
then
    source "${HOME}/.config/broot/launcher/bash/br"
fi

# local additions
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi

[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"
