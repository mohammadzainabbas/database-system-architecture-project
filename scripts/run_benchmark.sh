#! /bin/bash
#====================================================================================
# Author: Mohammad Zain Abbas
# Date: 11th Dec, 2021
#====================================================================================
# This script is used to run benchmark queries for DBSA Project
#====================================================================================

# Enable exit on error
set -e -u -o pipefail

# Import helper functions from 'scripts/utils.sh'
source $(dirname $0)/utils.sh

#Function that shows usage for this script
function usage()
{
cat << HEREDOC

Generates random 'range_type' data and run 'explain analyze' query to benchmark your join estimation(s).

Usage: 
    
    $progname [OPTION] [Value]

Options:

    -d, --database          Specify the name of your database. (by default 'dsa_project')
    -h, --help              Show usage

Examples:

    $ $progname -d demo_db
    ⚐ → Create tables in 'demo_db' and inserts random range_type data and run 'explain analyze' for join queries.

HEREDOC
}

#Get program name
progname=$(basename $0)

path=benchmarking_queries
database=dsa_project

#Get all the arguments and update accordingly
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--database) database="$2"; shift ;;
        -h|--help)
        usage
        exit 1
        ;;
        *) printf "\n$progname: invalid option → '$1'\n\n⚐ Try '$progname -h' for more information\n\n"; exit 1 ;;
    esac
    shift
done

# some sanity checks
check_dir $path
check_bin psql

run_psql() {
    local file=$1
    local database=$2
    check_file $file.sql
    log "Running '$file.sql'"
    psql -d $database -f ${file}.sql >> ${file}.log
    log "Sent query result(s) to '${file}.log'"
    separator
}

# files to run
files=(create_tables daterange_benchmarking numrange_benchmarking intrange_benchmarking tsrange_benchmarking)

# run 'psql' for all the files
for i in "${files[@]}"; do run_psql $path/$i $database; done

log "All done !!"
