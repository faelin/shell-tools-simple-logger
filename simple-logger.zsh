#!/bin/zsh

# zmodload "zsh/parameter" 

# get/set the log-severity level
declare -Ag log_level
log_level () {
  if [[ $# -gt 0 ]]; then
    case "$1" in
        1|warn|error)  log_level[$log_source]='1' ;;
        2|state|log)   log_level[$log_source]='2' ;;
        3|debug|stack) log_level[$log_source]='3' ;;
        *) log_level[$log_source]="$1" ;;
    esac

    debug "log_level for '${log_source}' is ${log_level[$log_source]}"
  else
    [ -n "${log_level[$log_source]}" ] && echo "${log_level[$log_source]}" || echo '0'
  fi

  return 0
}

log_source () {
  if [[ $# -gt 0 ]]; then
    log_source="$1"
  else
    [ -n "$log_source" ] && echo "$log_source" || echo "${funcfiletrace[2]}"
  fi

  return 0
}

log_destination () {
  if [[ $# -gt 0 ]]; then
    mkdir -p "$(dirname "$1")" || echo "LOGGER ERROR – could not create directory '$1': $!" >&2
    log_destination="$1"
  else
    [ -n "$log_destination" ] && echo "$log_destination"
  fi

  return 0
}

log_print () {
  [ "$(log_destination)" ] && echo "$@" | tee -a "$(log_destination)" || echo "$@"
}

export LOGGER_SOURCE_LOCATION="$0"
export LOG_COLOR_RESET='\033[0m'
export LOG_WARN_COLOR='\033[38;5;124m'
export LOG_STATE_COLOR='\033[0m'
export LOG_DEBUG_COLOR='\033[38;5;34m'
export LOG_STACK_COLOR='\033[38;5;140m'
warn  () { [[ `log_level` -gt 0 ]] && log_print "${LOG_WARN_COLOR}[$(log_source)] $@${LOG_COLOR_RESET}" >&2 || return 1 }
state () { [[ `log_level` -gt 1 ]] && log_print "${LOG_STATE_COLOR}[$(basename "${$(log_source)%%:*}" 2>/dev/null || echo 'terminal')] $@${LOG_COLOR_RESET}" >&2 || return 1 }
debug () { [[ `log_level` -gt 2 ]] && log_print "${LOG_DEBUG_COLOR}[${$(log_source)%%:*}$([ -n "${funcstack[2]}" ] && echo "::${funcstack[2]}"):${funcfiletrace[1]##*:}] $@${LOG_COLOR_RESET}" >&2 || return 1 }
stack () { [[ `log_level` -gt 2 ]] && log_print "${LOG_STACK_COLOR}> ${funcfiletrace[1]}$([[ $# -gt 0 ]] && echo " >> \"$@\"")\n  ${(j:\n  :)funcfiletrace[@]:1:-1}${LOG_COLOR_RESET}" >&2 || return 1 }

