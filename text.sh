if [[ ! $text_sh_already_sourced ]]; then

# This is a library that can be used by a Jenkins script or another library.

# Split line into array based on IFS-like delimiter
# Usage: dn=()
#        split "." $fqdn dn

split() {
    local IFS=$1 # IFS is reset locally to avoid clobbering global
    local line=$2
    local -n array=$3 # caller's array is passed by name reference
    set $line # reparse line with local internal field separator
    array=("$@") # assign parsed fields to caller's array
}

text_sh_already_sourced=1
fi