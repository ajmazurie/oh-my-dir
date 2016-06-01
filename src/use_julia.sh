# Ensure that a Julia environment is installed

# Syntax: use julia <julia version> [<environment name>]
#    <julia version>: version of the Julia compiler
#    <environment name>: environment name (default: 'default')

# Notes:
#    - powered by Playground.jl, see https://github.com/Rory-Finnegan/Playground.jl

use_julia() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax: should be 'use julia <julia version>'"
    fi

    ENV_NAME="${2:-default}"

    # ensure that playground is installed
    local PLAYGROUND_ROOT="${HOME}/.direnv/playground"
    if [[ ! -d ${PLAYGROUND_ROOT} ]]; then
        _print "installing Playground"
        OS_NAME=$(uname)

        if [ ${OS_NAME} == 'Darwin' ]; then
            package_name="v0.0.6_pre-alpha/playground-osx.tar.gz"
        elif [ ${OS_NAME} == 'Linux' ]; then
            package_name="v0.0.6_pre-alpha/playground-linux.tar.gz"
        else
            _error "unsupported platform: ${OS_NAME}"
        fi

        package="${TMPDIR:-/tmp}/playground.tar.gz"
        wget "https://github.com/Rory-Finnegan/Playground.jl/releases/download/${package_name}" -O ${package}
        tar xzf ${package} && rm ${package}
        echo $(dirname ${package})
        mv $(dirname ${package})/playground "${HOME}/.direnv/"
        ln -s "${HOME}/.playground" "${PLAYGROUND_ROOT}"
    fi

    # add playground to the PATH
    path_add LD_LIBRARY_PATH "${PLAYGROUND_ROOT}"
    path_add PATH "${PLAYGROUND_ROOT}"
    if ! has playground; then
        _error "playground not found"
    fi

    # ensure that this version of Julia compiler is installed
    if [[ ! -L ${PLAYGROUND_ROOT}/bin/julia-$1 ]]; then
        _print "installing Julia $1"
        playground install download $1
    fi

    # ensure that this environment exists
    local ENV_PATH="${PWD}/.env/playground-$1-${ENV_NAME}"
    if [[ ! -d ${ENV_PATH} ]]; then
        _print "preparing Julia environment '${ENV_NAME}'"
        mkdir -p "${ENV_PATH}/bin"
        ln -s "${PLAYGROUND_ROOT}/bin/julia-$1" "${ENV_PATH}/bin/julia"
    fi

    # activate this environment
    export JULIA_PKGDIR="${ENV_PATH}/lib"
    export JULIA_HISTORY="${ENV_PATH}/history"
    path_add PATH "${ENV_PATH}/bin"

    if [[ ! -d ${JULIA_PKGDIR} ]]; then
        julia --eval "Pkg.init()"
    fi
}
