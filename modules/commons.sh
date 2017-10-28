
# utility functions
_print() { printf "\e[1m$1\e[0m\n"; }
_error() { printf "\e[1;4merror\e[24m: $1\e[0m\n" >&2; exit 1; }
_ensure_line() {
    if [ ! -f $2 ]; then touch "$2"; fi
    grep -q -F "$1" "$2" || echo "$1" >> "$2"; }
