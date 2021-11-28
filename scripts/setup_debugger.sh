#! /bin/bash
#====================================================================================
# Author: Mohammad Zain Abbas
# Date: 28th Nov, 2021
#====================================================================================
# This script will setup the debugger in VS Code
#====================================================================================

# Enable exit on error
set -e -u -o pipefail

say() {
    echo $1
}

log() {
    say "[[ log ]] $1"
}

error() {
    say "[[ error ]] $1"
}

fatal_error () {
    error "$1"
    exit 1
}

check_dir() {
    if [ ! -d $1 ]; then
        fatal_error "Directory '$1' not found."
    fi
}

check_bin() {
    if which $1 >/dev/null; then
        log "'$1' exists in the path"
    else
        fatal_error "$2"
    fi
}

check_file() {
    if [ ! -f $1 ]; then
        fatal_error "File '$1' not found."
    fi
}

create_dir_if_not_exists() {
    if [ ! -d $1 ]; then
        log "Directory '$1' not found. Creating '$1' ..."
        mkdir -p $1 || error "Unable to create '$1' directory."
    fi
}

line_separator() {
    echo "\n========================================\n"
}

separator() {
    echo "\n----------------------------------------\n"
}

log "Checking if VS Code exists"

check_bin code "'code' was not found. Kindly, add 'code' into your path first."

log "Setting up debugger for VS Code"

code --install-extension vadimcn.vscode-lldb > /dev/null
say '{"version": "0.2.0","configurations":[{"name": "Debug PostgreSQL","type": "lldb","request": "attach","program": "/usr/local/pgsql/bin/postgres","pid": "${command:pickMyProcess}","args": [],"stopAtEntry": false,"cwd": "${fileDirname}","environment": [],"externalConsole": false,"MIMode": "lldb","targetArchitecture": "x86_64"}]}' >> launch.json
create_dir_if_not_exists .vscode
mv launch.json .vscode

log "All done! Enjoy debugging !!"