readonly RED='\e[91m'
readonly GRN='\e[92m'
readonly YEL='\e[93m'
readonly BLU='\e[94m'
readonly CYN='\e[96m'
readonly WHT='\e[97m'
readonly NONE='\e[0m'

QUIT_HOOK=()

clean_quit() {
    debug "entered clean_quit()"
    for hook in "${QUIT_HOOK[@]}"; do
        debug " - running $hook()"
        $hook
    done
    exit $1
}

debug() {
    if ((DEBUG)); then
        echo -e "${CYN}$*${NONE}" >&2
    fi
}

safety_message() {
    echo -e "${BLU}Safety Check:${NONE} $*"
}

errr() {
    echo -e "${RED}$*${NONE}" >&2
    clean_quit 1
}

split () {
    local IFS=$1 # IFS is reset locally to avoid clobbering global
    local line=$2
    local -n array=$3 # caller's array is passed by name reference
    set $line # reparse line with local internal field separator
    array=("$@") # assign parsed fields to caller's array
}
