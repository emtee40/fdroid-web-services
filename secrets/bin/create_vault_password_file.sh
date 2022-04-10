#! /bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}/.."

RECIPIENTS=(
  --recipient 37D2C98789D8311948394E3E41E7044E1DBA2E89  # admin@f-droid.org
  --recipient D1EDF03688F3FD72A24EE73BDA9F4A3A07F6EC0C  # ciaran@ciarang.com
  --recipient EE6620C7136B0D2C456C0A4DE9E28DEA00AA5556  # hand@guardianproject.info
  --recipient EF909D4AD7079062A0BA1DD7725F386C05529A5A  # michael.poehn@fsfe.org
)


pwgen 64 1 | gpg --armor --sign --encrypt \
  "${RECIPIENTS[@]}" \
  --local-user EF909D4AD7079062A0BA1DD7725F386C05529A5A \
  --output vault_password
