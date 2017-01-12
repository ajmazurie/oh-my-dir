# use_conda: Ensure that a Conda package manager is installed and enabled (stable)

# Syntax: use conda [<environment name>]
#    <environment name>: name of the environment (default: 'default')

# Notes:
#    - the Conda environment is populated with Python 2.x

use_conda() {
    ENV_NAME="${1:-default}"

    # ensure that conda is installed
    export CONDA_ROOT="${HOME}/.direnv/conda"
    if [[ ! -d ${CONDA_ROOT} ]]; then
        OS_NAME="$(uname)"; WORD_SIZE=$(getconf LONG_BIT)

        if [ "${OS_NAME}" == "Darwin" ]; then
            _print "conda: installing Conda package manager (64bit)"
            package_name="Miniconda2-latest-MacOSX-x86_64"
        elif [ "${OS_NAME}" == "Linux" ]; then
            if [ "${WORD_SIZE}" == "64" ]; then
                _print "conda: installing Conda package manager (64bit)"
                package_name="Miniconda2-latest-Linux-x86_64"
            else
                _print "conda: installing Conda package manager (32bit)"
                package_name="Miniconda2-latest-Linux-x86"
            fi
        else
            _error "unsupported platform: ${OS_NAME}"
        fi

        package="${TMPDIR:-/tmp}/miniconda.sh"
        wget "https://repo.continuum.io/miniconda/${package_name}.sh" -O ${package}
        bash ${package} -b -p ${CONDA_ROOT} && rm ${package}
    fi

    # add miniconda to the PATH
    path_add PATH "${CONDA_ROOT}/bin"
    if ! has conda; then
        _error "conda: 'conda' executable not found"; fi

    # ensure that this environment exists
    local ENV_PATH="${PWD}/.env/conda-${ENV_NAME}"
    if [[ ! -d ${ENV_PATH} ]]; then
        _print "conda: preparing Conda environment '${ENV_NAME}'"
        conda create --prefix "${ENV_PATH}" --quiet python > /dev/null
    fi

    # activate this environment
    source activate "${ENV_PATH}"
}
