set -x -p PATH /usr/local/sbin /usr/local/bin /usr/bin/core_perl
if type -q ruby > /dev/null
    set -x GEM_HOME (ruby -e 'print Gem.user_dir')
    set -l gempath $GEM_HOME/bin
    if test -d $gempath
        set -x -p PATH $gempath
    end
end
if test -d ~/local/bin
    set -x PATH -p ~/local/bin
end
if test -d ~/.local/bin
    set -x -p PATH ~/.local/bin
end
if test -d ~/.cargo/bin
    set -x -p PATH ~/.cargo/bin
end
if test -d ~/.npm/bin
    set -x -p PATH ~/.npm/bin
end

# determine the editor to use
if type -q nvim
    set -x EDITOR nvim
else
    set -x EDITOR vim
end
set -x VISUAL $EDITOR

# color support
if type -q dircolors
    eval (dircolors -c)
else if type -q gdircolors
    eval (gdircolors -c)
end

# disable the greeting
set -x fish_greeting ""

# indicate to GPG which terminal can be used
set -x GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# SSH agent settings
if ! set -q SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

# pyenv support
if type -q pyenv > /dev/null; and status --is-interactive
    set -x PYENV_ROOT $HOME/.pyenv
    set -x -p PATH $PYENV_ROOT/bin
    pyenv init --no-rehash --path | source
    pyenv init --no-rehash - | source
    pyenv virtualenv-init - | source
end

if type -q starship > /dev/null
    status --is-interactive; and starship init fish | source
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

set -x ZK_NOTEBOOK_DIR ~/Nextcloud/notes/zettelkasten/

# check for new mail
check_mail

[ -s ~/.jabba/jabba.fish ]; and source ~/.jabba/jabba.fish
