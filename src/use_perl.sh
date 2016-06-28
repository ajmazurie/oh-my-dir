# Ensure that a Perl environment is installed

# Syntax: use perl <perl version> [<environment name>]
#    <perl version>: version of the Perl interpreter
#    <environment name>: environment name (default: 'default')

# Notes:
#    - powered by Perlbrew, see http://perlbrew.pl/

use_perl() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax; should be 'use perl <perl version>'"
    fi

    ENV_NAME="${2:-default}"

    # ensure that {erlbrew is installed
    export PERLBREW_ROOT="${HOME}/.direnv/perlbrew"
    export PERLBREW_HOME="${PERLBREW_ROOT}"
    if [[ ! -d ${PERLBREW_ROOT} ]]; then
        _print "perl: installing Perlbrew"
        curl -L http://install.perlbrew.pl | bash
    fi

    source "${PERLBREW_HOME}/etc/bashrc"
    if ! has perlbrew; then
        _error "perl: 'perlbrew' executable not found"
    fi

    # ensure that this version of Perl interpreter is installed
    if ! perlbrew use $1; then
        _print "perl: installing Perl interpreter $1"
        perlbrew install --notest $1
        perlbrew use $1
        perlbrew install-cpanm
    fi

    # ensure that this environment exists
    local ENV_PATH="${PWD}/.env/perlbrew-$1-${ENV_NAME}"
    if [[ ! -d ${ENV_PATH} ]]; then
        _print "perl: preparing Perl environment '${ENV_NAME}'"
        mkdir -p "${ENV_PATH}"
    fi

    # activate this environment
    export PERL_LOCAL_LIB_ROOT="${ENV_PATH}"
    export PERL5LIB="${PERL_LOCAL_LIB_ROOT}/lib/perl5"
    export PERL_MB_OPT="--install_base ${PERL_LOCAL_LIB_ROOT}"
    export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}"
}
