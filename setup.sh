#!/bin/bash

source functions.sh

show_help() {
  echo "Usage: setup.sh [OPTIONS]"
  echo ""
  echo "This script assumes a clean image!"
  echo "Runs all functions in 'functions.sh' if no options are specified."
  echo ""
  echo "Options:"
  echo "  -o FUNCTION   Run only the specified function"
  echo "  -e FUNCTION   Exclude the specified function and run all others"
  echo "  -a FUNCTION   Run the specified function and all following functions"
  echo "  -h            Display this help message"
}

get_functions() {
  local script_file="functions.sh"
  functions_list=($(awk '/^[[:blank:]]*function[[:blank:]]+|^[[:blank:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:blank:]]*\(\)[[:blank:]]*{/{gsub(/\(\).*/, "", $1); print $1}' "$script_file"))
}

run_function() {
  local function_name=$1
  if declare -F "$function_name" > /dev/null; then
    echo "Running $function_name..."
    $function_name
  else
    echo "Invalid function name: $function_name"
    exit 1
  fi
}

run_functions_from() {
  local start_function=$1
  local start=false
  for function in "${functions_list[@]}"; do
    if [ "$function" = "$start_function" ]; then
      start=true
    fi
    if [ "$start" = true ]; then
      run_function "$function"
    fi
  done
}

run_all_functions() {
  for function in "${functions_list[@]}"; do
    run_function "$function"
  done
}

exclude_function() {
  local exclude_function=$1
  for function in "${functions_list[@]}"; do
    if [ "$function" != "$exclude_function" ]; then
      run_function "$function"
    fi
  done
}

if ! [[ "$@" =~ "-h" ]]; then
  get_functions
  echo "WARNING! this script assumes a clean image!"
  echo "Do not run if this is not a clean image!"
  echo "Press enter to continue..."
  read -r
fi

while getopts "o:e:a:h" opt; do
  case ${opt} in
    o )
      run_function "$OPTARG"
      ;;
    e )
      exclude_function "$OPTARG"
      ;;
    a )
      run_functions_from "$OPTARG"
      ;;
    h )
      show_help
      exit 0
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      show_help
      exit 1
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ $OPTIND -eq 1 ]; then
  run_all_functions
fi

