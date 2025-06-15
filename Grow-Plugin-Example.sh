#!/bin/sh
echo -ne '\033c\033]0;Grow-Plugin-Example\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Grow-Plugin-Example.x86_64" "$@"
