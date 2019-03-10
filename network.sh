if [[ ! $network_sh_already_sourced ]]; then

# This is a library that can be used by a Jenkins script or another library.
# We export useful constants and functions from local libraries to the remote.

source ./common/base.sh

ssh="ssh"

rexec() {
    local user=root
    local host=$1 # default to bare host - user and port are optional
    local port=22

    # Host may be plain host or ip, user@host, host:port
    # or the trifecta: user@host:port

    # user may precede @ 
    [[ $1 =~ ^(.*)@ ]] && {
        user=${BASH_REMATCH[1]}
    }

    # host may follow an @ or precede a :
    [[ $1 =~ @([^@:]*) ]] && {
        host=${BASH_REMATCH[1]}
    }
    [[ $1 =~ ([^@:]*): ]] && {
        host=${BASH_REMATCH[1]}
    }

    # port may follow a :
    [[ $1 =~ :(.*)$ ]] && {
        port=${BASH_REMATCH[1]};
    }

    local code=$2 # single-quoted code to be executed remotely...
    if [[ -f $2 ]]; then # ...or a filename
        # code=$(cat $code) # This can be used when local machine is Linux
        code=$(sed "s/\r\n$/\n$/" $code) # This is needed for Windows
    fi

    shift 2 # shift off the first two args, remaining are namerefs

    {
        # auto-declare useful base.sh variables and functions
        declare -p RED GRN YEL BLU CYN WHT NONE loglevel DEBUG INFO WARN ERROR clean_hooks
        declare -f debug info warn err errr clean_quit
        # declare the remaining arguments as function or variable refs
        for ref in "$@"; do
            declare -f $ref || declare -p $ref
        done
        echo "$code"
    } | $ssh -p $port $host sudo -u $user "bash -s"
}

network_sh_already_sourced=1
fi