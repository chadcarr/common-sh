if [[ ! $network_sh_already_sourced ]]; then

# This is a library that can be used by a Jenkins script or another library.
# We export useful constants and functions from local libraries to the remote.

source ./common/base.sh

ssh="ssh"

rexec() {
    local port=22
    local user=root
    declare host code refs

    while ((${#@})); do
        case "$1" in
            -u|--user)
                user=$2
                shift 2
            ;;
            -h|--host)
                host=$2
                shift 2
            ;;
            -p|--port)
                port=$2
                shift 2
            ;;
            -f|--file)
                if [[ -f $2 ]]; then
                    # code=$(cat $2)
                    code=$(sed "s/\r\n$/\n$/" $2) # This is needed for Windows
                else
                    error "file not found: $2"
                    return 2
                fi
                shift 2
            ;;
            -e|--expression)
                code=$2
                shift 2
            ;;
            *)
                refs=("$@")
                shift $#
            ;;
        esac
    done

    # require host and code
    if [[ ! $host ]]; then
        error "must provide remote host or IP address (-h|--host)"
        return 2
    elif [[ ! $code ]]; then
        error "must provide file (-f|--file) or expression (-e|--expression) for remote execution"
        return 2
    else
        debug "host: $host, user: $user, port: $port, refs: $refs[@]"
        debug "code:\n$code"
    fi

    {
        declare -p RED GRN YEL BLU CYN WHT C_RED NONE
        declare -p loglevel DEBUG INFO WARN ERROR CRITICAL
        declare -f debug info warn error critical
        for ref in ${refs[@]}; do
            declare -f $ref || declare -p $ref
        done
        echo "$code"
    } | $ssh -p $port $host sudo -u $user "bash -s"
}

network_sh_already_sourced=1
fi