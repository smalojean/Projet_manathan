#!/bin/sh
printf '\033c\033]0;%s\a' BionicComando
base_path="$(dirname "$(realpath "$0")")"
"$base_path/BionicComando.x86_64" "$@"
