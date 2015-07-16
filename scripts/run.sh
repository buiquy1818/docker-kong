#!/usr/bin/env bash

# Include tools
source "${SCRIPTSDIR}/tools.sh"

# Run
case "$@" in
#    configure)
#        echo "Configuring..."
#    ;;
    *)
        echo "Running Kong..."
#        check_up "Cassandra DB" "cassandra" 9042
        sleep 10
        kong start
    ;;
esac
