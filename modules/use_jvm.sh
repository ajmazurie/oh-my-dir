# use_jvm: Ensure that a JVM environment is installed and enabled (stable)

# Syntax: use jvm <package_name> [package_version]
#    package_name: name of the SDKMAN! package (required)
#    package_version: version of the SDKMAN! package (optional)

# Notes:
#    - powered by SDKMAN!, see http://sdkman.io/

use_sdkman() {
    # ensure that SDKMAN! is installed
    export SDKMAN_DIR="${HOME}/.direnv/sdkman"
    if [[ ! -d ${SDKMAN_DIR} ]]; then
        _print "jvm: installing SDKMAN!"
        curl -s "https://get.sdkman.io" | bash
    fi

    # add SDKMAN! to the PATH
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    if ! has sdk; then
        _error "jvm: 'sdk' executable not found"
    fi
}

use_jvm() {
    if [[ $# -lt 1 ]]; then
        _error "invalid syntax: should be 'use jvm <package name> <package version>'"
    fi

    use sdkman

    # ensure that this JVM package is installed
    if [[ ! -d ${SDKMAN_DIR}/candidates/$1 ]]; then
        _print "jvm: installing JVM package $1"
        USE=n sdk install $1 $2
    fi

    # activate this package
    sdk use $1 $2
}
