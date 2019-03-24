set -x PATH /usr/local/sbin /usr/local/bin /usr/bin/core_perl $PATH
if command -v ruby > /dev/null
    if test -d (ruby -e "puts Gem.user_dir")/bin
        set -x PATH (ruby -e "puts Gem.user_dir")/bin $PATH
    end
end
if test -d ~/local/bin
    set -x PATH ~/local/bin $PATH
end
if test -d ~/.local/bin
    set -x PATH ~/.local/bin $PATH
end
if test -d ~/.cargo/bin
    set -x PATH ~/.cargo/bin $PATH
end
if test -d ~/.npm/bin
    set -x PATH ~/.npm/bin $PATH
end

if command -v ruby > /dev/null
    set -x GEM_HOME (ruby -e 'print Gem.user_dir')
end

# pass settings
set -x PASSWORD_STORE_CLIP_TIME 20
set -x PASSWORD_STORE_ENABLE_EXTENSIONS "true"

# determine the editor to use
if which nvim 2> /dev/null > /dev/null
    set -x EDITOR nvim
else
    set -x EDITOR vim
end
set -x VISUAL $EDITOR

# color support
if test -f ~/.dircolors
    eval (dircolors -c ~/.dircolors | sed 's/>&\/dev\/null$//')
end

# disable the greeting
set -x fish_greeting ""

# indicate to GPG which terminal can be used
set -x GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# SSH agent settings
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# pyenv support
if command -v pyenv > /dev/null
    status --is-interactive; and source (pyenv init -|psub)
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end

# local config
if test -f ~/.config/fish/localconfig.fish
    source ~/.config/fish/localconfig.fish
end

# enable homeshick if possible
if test -f "$HOME/.homesick/repos/homeshick/homeshick.fish"
    source "$HOME/.homesick/repos/homeshick/homeshick.fish"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick.fish"
    if status --is-interactive
        homeshick --quiet refresh
    end
end

# check for new mail
check_mail
