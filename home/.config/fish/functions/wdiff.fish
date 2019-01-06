function wdiff
    command wdiff -w (tput bold;tput setaf 1) -x (tput sgr0) -y (tput bold;tput setaf 2) -z (tput sgr0) $argv
end
