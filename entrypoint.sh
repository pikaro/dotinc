_DOTINC="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

set -ua

source "${_DOTINC}/aliases.sh"
source "${_DOTINC}/common.sh"

set +ua

unset _DOTINC
