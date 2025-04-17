_function_exists() {
    declare -f -F $1 >/dev/null
    return $?
}

for _al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
    alias g${_al}="git ${_al}"
done

unset _al
unset _function_exists
