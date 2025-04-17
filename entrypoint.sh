_SHELL="$(ps -p $$ -o comm=)"

if [ "${_SHELL}" = "bash" ]; then
    SOURCE="${BASH_SOURCE[0]}"
elif [ "${_SHELL}" = "zsh" ]; then
    SOURCE="${(%):-%x}"
else
    echo "Unsupported shell. Please use bash or zsh."
    exit 1
fi

REAL_SOURCE="$(readlink -f "${SOURCE}")"
DOTINC="$(dirname "${REAL_SOURCE}")"

set -ua

source "${DOTINC}/aliases.sh"
source "${DOTINC}/common.sh"

set +ua

_debug "Loaded shell functions from ${DOTINC}"

unset DOTINC
