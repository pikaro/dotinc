_log() {
    stdbuf -o0 -e0 echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >/dev/stderr
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
