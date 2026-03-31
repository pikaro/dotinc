_function_exists() {
    declare -f -F $1 >/dev/null
    return $?
}

for _al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
    alias g${_al}="git ${_al}"
done

unset _al
unset _function_exists

hyperlink() {
    local URL="$1"
    local TEXT="${2:-${URL}}"
    printf '\e]8;;%s\e\\%s\e]8;;\e\\' "$URL" "$TEXT"
}

urlencode() {
    local STRING="${1}"
    local LENGTH="${#STRING}"
    local ENCODED=""
    for ((i = 0; i < LENGTH; i++)); do
        local CHAR="${STRING:i:1}"
        case "${CHAR}" in
        [a-zA-Z0-9._~-]) ENCODED+="${CHAR}" ;;
        *) ENCODED+=$(printf '%%%02X' "'${CHAR}") ;;
        esac
    done
    echo "${ENCODED}"
}
