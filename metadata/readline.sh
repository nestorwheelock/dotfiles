#!/usr/bin/env bash

# Source in common metadata functions
script_dir="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck source=metadata/templates/common.sh
source "$script_dir/templates/common.sh"

kernel_name=$(uname -s)
if [ "${kernel_name#*Linux}" != "$kernel_name" ]; then
    if ! dpkg --get-selections | egrep '^libreadline' > /dev/null; then
        exit $DETECTION_NOT_AVAILABLE
    fi
elif [ "${kernel_name#*CYGWIN_NT}" != "$kernel_name" ]; then
    if ! cygcheck -c -d | egrep '^libreadline' > /dev/null; then
        exit $DETECTION_NOT_AVAILABLE
    fi
else
    exit $DETECTION_NO_LOGIC
fi

exit $DETECTION_SUCCESS

# vim: syntax=sh cc=80 tw=79 ts=4 sw=4 sts=4 et sr
