if [[ ! $base_sh_already_sourced ]]; then

# This is a library that can be used by a Jenkins script or another library.

# Escape sequences for colorizing echo -e

RED='\e[91m'
GRN='\e[92m'
YEL='\e[93m'
BLU='\e[94m'
CYN='\e[96m'
WHT='\e[97m'
C_RED='\e[93;41m'
NONE='\e[0m'

# Logging code
# Usage: loglevel=$ERROR [DEBUG|INFO|WARN|ERROR|CRITICAL]
#        debug "value of var is $var"
#        info "running rollback functions"
#        warn "--option is deprecated, use -o instead"
#        error "unable to connect to $host"
#        critical "$host is missing mount point"

CRITICAL=-1
ERROR=0
WARN=1
INFO=2
DEBUG=3

loglevel=$ERROR

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

error() {
    if [[ $loglevel -ge $ERROR ]]; then
        echo -e "${RED}Error: $*${NONE}" >&2
    fi
}

critical() {
    if [[ $loglevel -ge $CRITICAL ]]; then
        echo -e "${C_RED}CRITICAL: $*${NONE}" >&2
    fi
}

# Rollback code
# Usage: clean_hooks+=(rollback_function)
#        errr "invalid operation: rolling back changes"
#        OR
#        clean_quit $exit_code

clean_hooks=()

clean_quit() {
    debug "entered clean_quit()"
    for hook in "${clean_hooks[@]}"; do
        debug " - running $hook()"
        $hook
    done
    exit $1
}

errr() {
    error "$@"
    clean_quit 1
}

base_sh_already_sourced=1
fi