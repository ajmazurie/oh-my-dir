# Ensure that a Docker machine of a given type and name
# exists and is accessible to the other Docker tools

# Syntax: use docker-machine [<machine name>] [<machine driver>]
#    <machine name>: name of the Docker machine (default: 'default')
#    <machine driver>: driver for the Docker machine (default: 'virtualbox');
#        for a list of supported drivers see https://docs.docker.com/machine

# Notes:
#    - the resulting Docker machine will have RSYNC installed

use_docker-machine() {
    ENV_NAME="${1:-default}"
    ENV_TYPE="${2:-virtualbox}"

    # if this platform has a need for docker-machine,
    if has docker-machine; then
        # ensure that a machine with the requested name exists
        if ! docker-machine ls | grep ${ENV_NAME} > /dev/null; then
            docker-machine create --driver ${ENV_TYPE} ${ENV_NAME}
            docker-machine ssh ${ENV_NAME} -- tce-load -wi rsync
        fi

        # then export its environment variables
        eval $(docker-machine env ${ENV_NAME})
    fi
}
