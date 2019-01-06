function tpass --wraps=pass
    set -x PASSWORD_STORE_CLIP_TIME 20
    set -x PINENTRY_USER_DATA term
    command pass $argv
end
