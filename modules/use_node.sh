
# Syntax: use node <node version>
#    <node version>: version of the Node interpreter

# Notes:
#    - powered by nvm, see https://github.com/creationix/nvm

use_nvm() {
    # ensure that nvm is installed
    export NVM_DIR="${HOME}/.direnv/nvm"
    if [[ ! -d ${NVM_DIR} ]]; then
        _print "node: installing nvm"
        git clone https://github.com/creationix/nvm.git "${NVM_DIR}"
        cd "${NVM_DIR}"
        git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    fi

    # add nvm shims to the PATH
    source "${NVM_DIR}/nvm.sh"
    if ! has nvm; then
        _error "node: 'nvm' executable not found"
    fi
}

use_node() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax: should be 'use nvm <node version>'"
    fi

    use nvm

    # ensure that this version of Node interpreter is installed
    if [[ ! -d ${NVM_DIR}/versions/node/v$1 ]]; then
        _print "node: installing node interpreter $1"
        nvm install $1
    fi

    # activate this interpreter
    nvm use $1
}
