_DOTINC="$(dirname "$(readlink -f "$0")")"
set -ua

echo "$_DOTINC"

source "${_DOTINC}/aliases.sh"

set +ua

unset _DOTINC
