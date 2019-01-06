function gpg
    if which gpg2 2> /dev/null > /dev/null
        gpg2 $argv
    else
        command gpg $argv
    end
end
