function fish_title
    if test -n "$__fish_user_title"
        echo -n $__fish_user_title': '
    end
    echo $_ (pwd) | sed 's|'{$HOME}'|~|'
end
