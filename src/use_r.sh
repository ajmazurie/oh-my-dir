# use_r: Ensure that a R environment is installed and enabled (stable)

# Syntax: use R [<environment name>]
#    <environment name>: environment name (default: 'default')

use_R() {
    ENV_NAME="${1:-default}"

    # check that R is installed
    if ! has R; then
        _error "R: 'R' executable not found"; fi

    if ! has Rscript; then
        _error "R: 'Rscript' executable not found"; fi

    local R_VERSION=$(Rscript -e "cat(paste(getRversion()))")
    local ENV_PATH="${PWD}/.env/R-${R_VERSION}-${ENV_NAME}"

    if [[ ! -d ${ENV_PATH} ]]; then
        _print "R: preparing R environment '${ENV_NAME}'"
        mkdir -p "${ENV_PATH}"
    fi

    export R_LIBS="${ENV_PATH}"
}
