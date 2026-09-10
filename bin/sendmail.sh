#!/usr/bin/env bash

function main() {
    email="$1"
    body="test"
    echo "email=$email"
    subject="test"

    body=$(date '+%Y-%m-%d %H:%M:%S %Z')
    body+='\n'
    body+=$(ls -l output/)

    echo "$body" | mail -s "$subject" "$email"

}
main "$*"
