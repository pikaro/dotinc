_SHELL="$(ps -p $$ -o comm=)"

if [[ "${_SHELL}" == *"bash" ]]; then
    SOURCE="${BASH_SOURCE[0]}"
    export SHELL_NAME="bash"
elif [[ "${_SHELL}" == *"zsh" ]]; then
    SOURCE="${(%):-%x}"
    export SHELL_NAME="zsh"
else
    echo "Unsupported shell: ${_SHELL}. Please use bash or zsh."
fi

REAL_SOURCE="$(readlink -f "${SOURCE}")"
DOTINC="$(dirname "${REAL_SOURCE}")"

set -ua

source "${DOTINC}/aliases.sh"
source "${DOTINC}/common.sh"

_source_dir() {
    local DIR_PATH=$1

    while IFS= read -r -d '' FILE; do
        # shellcheck source=/dev/null
        source "${FILE}"
    done < <(find "${DIR_PATH}" -type f -name "*.sh" -print0 | sort -z)
}

if [ -d "${DOTINC}/${SHELL_NAME}.d" ]; then
    _source_dir "${DOTINC}/${SHELL_NAME}.d"
fi

if [ -d "${HOME}/.local/dotinc.${SHELL_NAME}.d" ]; then
    _source_dir "${HOME}/.local/dotinc.${SHELL_NAME}.d"
fi

set +ua

_debug "Loaded shell functions from ${DOTINC}"

unset DOTINC
