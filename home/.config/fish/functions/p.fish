function p
    if which wl-paste 2> /dev/null > /dev/null
        wl-paste
    else if which xclip 2> /dev/null > /dev/null
        xclip -selection clipboard -o
    else if which pbcopy 2> /dev/null > /dev/null
        pbpaste
    end
end
