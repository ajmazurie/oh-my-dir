# Ensure that a Python environment is installed

# Syntax: use python <python version> [<environment name>]
#    <python version>: version of the Python interpreter
#    <environment name>: environment name (default: 'default')

# Notes:
#    - powered by Pyenv, see https://github.com/yyuu/pyenv

use_python() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax: should be 'use python <python version>'"
    fi

    ENV_NAME="${2:-default}"

    # ensure that Pyenv is installed
    export PYENV_ROOT="${HOME}/.direnv/pyenv"
    if [[ ! -d ${PYENV_ROOT} ]]; then
        _print "installing Pyenv"

        curl -L "https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer" | bash
    fi

    # add pyenv to the PATH
    path_add PATH "${PYENV_ROOT}/bin"
    path_add PATH "${PYENV_ROOT}/shims"
    if ! has pyenv; then
        _error "pyenv not found"
    fi

    # ensure that this version of Python interpreter is installed
    if [[ ! -d ${PYENV_ROOT}/versions/$1 ]]; then
        _print "installing Python $1"
        pyenv install --skip-existing $1
        pyenv exec pip install --upgrade pip
        pyenv exec pip install --quiet virtualenv
        pyenv rehash
    fi
    export PYENV_VERSION=$1

    # ensure that this environment exists
    local ENV_PATH="${PWD}/.env/pyenv-$1-${ENV_NAME}"
    if [[ ! -d ${ENV_PATH} ]]; then
        _print "preparing Python environment '${ENV_NAME}'"
        virtualenv --always-copy "${ENV_PATH}"
    fi

    # activate this environment
    export PYENV_VIRTUALENV_DISABLE_PROMPT=0
    source "${ENV_PATH}/bin/activate"
}
