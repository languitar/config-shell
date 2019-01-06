function fish_user_key_bindings
    bind \e\[7~ beginning-of-line
    bind \e\[8~ end-of-line
    if functions --query fzf_key_bindings
        fzf_key_bindings
    end
end
