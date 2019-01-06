function check_mail
    if test -n "$MAIL"
        if test -s "$MAIL"
            echo "You have new mail!"
        end
    end
end
