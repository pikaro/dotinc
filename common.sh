SCRIPT="$(basename "$0")"

_log() {
    stdbuf -o0 -e0 echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] [${SCRIPT}] $*" >/dev/stderr
}

_warn() {
    _log "[WARN] $*"
}

_error() {
    _log "[ERROR] $*"
}

_info() {
    _log "[INFO] $*"
}

_fatal() {
    _log "[FATAL] $*"
    exit 1
}

_debug() {
    if [[ "${DEBUG}" == "true" ]]; then
        _log "[DEBUG] $*"
    fi
}

_COL_black=30
_COL_red=31
_COL_green=32
_COL_yellow=33
_COL_blue=34
_COL_magenta=35
_COL_cyan=36
_COL_white=37
_COL_bright_black=90
_COL_bright_red=91
_COL_bright_green=92
_COL_bright_yellow=93
_COL_bright_blue=94
_COL_bright_magenta=95
_COL_bright_cyan=96
_COL_bright_white=97

_color() {
    local COLOR="${1}"
    local TEXT="${2}"
    local COL_VAR="_COL_${COLOR// /_}"
    printf "\e[${!COL_VAR}m%s\e[0m" "${TEXT}"
}
