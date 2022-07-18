function c
    if which wl-copy 2> /dev/null > /dev/null
        wl-copy
    else if which xclip 2> /dev/null > /dev/null
        xclip -selection clipboard
    else if which pbcopy 2> /dev/null > /dev/null
        pbcopy
    end
end
