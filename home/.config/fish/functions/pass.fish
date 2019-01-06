function pass --wraps=pass
    set -x PASSWORD_STORE_CLIP_TIME 20
    command pass $argv
end
