function vim
    if which nvim 2> /dev/null > /dev/null
        ulimit -c unlimited
        nvim $argv
    else
        eval (which vim) $argv
    end
end
