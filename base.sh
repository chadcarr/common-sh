if [[ ! $base_sh_already_sourced ]]; then

# This is a library that can be used by a Jenkins script or another library.

RED='\e[91m'
GRN='\e[92m'
YEL='\e[93m'
BLU='\e[94m'
CYN='\e[96m'
WHT='\e[97m'
NONE='\e[0m'

clean_hooks=()

clean_quit() {
    debug "entered clean_quit()"
    for hook in "${clean_hooks[@]}"; do
        debug " - running $hook()"
        $hook
    done
    exit $1
}

ERROR=0
WARN=1
INFO=2
DEBUG=3
declare -i loglevel

debug() {
    if [[ $loglevel -ge $DEBUG ]]; then
        echo -e "${CYN}Debug: $*${NONE}" >&2
    fi
}

info() {
    if [[ $loglevel -ge $INFO ]]; then
        echo -e "${BLU}Info: $*${NONE}"
    fi
}

warn() {
    if [[ $loglevel -ge $WARN ]]; then
        echo -e "${YEL}Warning: $*${NONE}" >&2
    fi
}

err() {
    if [[ $loglevel -ge $ERROR ]]; then
        echo -e "${RED}Error: $*${NONE}" >&2
    fi
}

errr() {
    err "$@"
    clean_quit 1
}

split() {
    local IFS=$1 # IFS is reset locally to avoid clobbering global
    local line=$2
    local -n array=$3 # caller's array is passed by name reference
    set $line # reparse line with local internal field separator
    array=("$@") # assign parsed fields to caller's array
}

base_sh_already_sourced=1
fi