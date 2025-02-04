#!/bin/bash
#
# This script syncs the entire repo to the primary mirrors.  It is
# meant to run in a cronjob quite frequently, as often as there are
# files to send.
#
# This script expects the receiving side to have the following
# preceeding the ssh key entry in ~/.ssh/authorized_keys:
#
#   restrict,command="rsync --server -logDtpre.iLsfx --log-format=X --delete --delay-updates . /path/to/htdocs/fdroid/"
#
set -e
set -x

section=$1
test -n "$section"
host=$2
test -n "$host"

if [ "$section" == "archive" ]; then
    timeout=600
else
    timeout=10
fi
echo "Waiting $timeout seconds for lock..."
(
    flock --exclusive --timeout $timeout 200
    echo "Pushing $section to $host at $(date):"

    # be super careful with the trailing slashes here! if one is wrong, it'll delete the entire section!
    rsync --archive --delay-updates --progress --delete \
          --timeout=3600 \
          "/var/www/fdroid/${section}" \
          "fdroid@${host}:/srv/fdroid-mirror.at.or.at/htdocs/fdroid/"

) 200>"/run/lock/$(whoami)_$(basename "$0")_${host}"
