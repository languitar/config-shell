function man --description 'Format and display the on-line manual pages'

    set -x LESS_TERMCAP_mb (printf "\e[1;37m")
    set -x LESS_TERMCAP_me (printf "\e[0m")
    set -x LESS_TERMCAP_se (printf "\e[0m")
    set -x LESS_TERMCAP_so (printf "\e[1;47;30m")
    set -x LESS_TERMCAP_ue (printf "\e[0m")
    set -x LESS_TERMCAP_us (printf "\e[0;36m")

    # Work around OS X's "builtin" manpage that everything symlinks to,
    # by prepending our fish datadir to man. This also ensures that man gives fish's
    # man pages priority, without having to put fish's bin directories first in $PATH
    # Temporarily set a MANPATH, unless one is set already
    if not set -q MANPATH
        set -l fish_manpath (dirname $__fish_data_dir)/fish/man
        if test -d "$fish_manpath"
            # Notice local but exported variable
            set -lx MANPATH "$fish_manpath":(command manpath)

            # Invoke man with this manpath, and we're done
            command man $argv
            return
        end
    end

    # If MANPATH is set explicitly, or fish's man pages could not be found,
    # just invoke man normally
    command man $argv
end
