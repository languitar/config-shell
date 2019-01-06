function c
    if which xclip 2> /dev/null > /dev/null
        xclip -selection clipboard
    else if which pbcopy 2> /dev/null > /dev/null
        pbcopy
    end
end
