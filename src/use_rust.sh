# Creation of local Rust environments
# syntax: use rust <rust version> [<environment name>]
#   <rust version>: mandatory; version of the Rust compiler
#   <environment name>: optional; environment name (default: 'default')

# Powered by rsvm, see http://sdepold.github.io/rsvm/

use_rust() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax: should be 'use rust <rust version>'"
    fi

    ENV_NAME="${2:-default}"

    # ensure that rsvm is installed
    export RSVM_ROOT="${HOME}/.direnv/rsvm"
    if [[ ! -d ${RSVM_ROOT} ]]; then
        _print "installing rsvm"

        if ! has git; then
            _error "git not found"
        fi

        git clone git://github.com/sdepold/rsvm.git ${RSVM_ROOT}
    fi

    source "${RSVM_ROOT}/rsvm.sh"
    if ! has rsvm; then
        _error "rsvm not found"
    fi

    # ensure this version of Rust compiler is installed
    if [[ ! -d ${RSVM_ROOT}/versions/$1 ]]; then
        _print "installing Rust $1"
        rsvm install $1
        rm -rf "${RSVM_ROOT}/current"
    fi

    local RUST_ROOT="${RSVM_ROOT}/versions/$1"
    path_add PATH "${RUST_ROOT}/dist/bin"
    path_add LD_LIBRARY_PATH "${RUST_ROOT}/dist/lib"
    path_add DYLD_LIBRARY_PATH "${RUST_ROOT}/dist/lib"
    path_add MANPATH "${RUST_ROOT}/dist/share/man"
    export RSVM_SRC_PATH="${RUST_ROOT}/src/rustc-source/src"
}
