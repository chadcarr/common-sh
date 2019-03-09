RED='\e[91m'
GRN='\e[92m'
YEL='\e[93m'
BLU='\e[94m'
CYN='\e[96m'
WHT='\e[97m'
NONE='\e0m'

QUIT_HOOK=()

clean_quit() {
    for hook in "${QUIT_HOOK[@]}"; do
        debug " - running $hook()"
        $hook
    done
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
    echo -e "$RED$*$NONE" >&2
    clean_quit 1
}

split () {
    local IFS=$1 # IFS is reset locally to avoid clobbering global
    local line=$2
    local -n array=$3 # caller's array is passed by name reference
    set $line # reparse line with local internal field separator
    array=("$@") # assign parsed fields to caller's array
}
