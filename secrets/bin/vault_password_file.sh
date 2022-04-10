#!/bin/sh -e
#
# redirect the signature verification to /dev/null

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}/.."

gpg --quiet --batch --no-tty --decrypt vault_password 2> /dev/null
