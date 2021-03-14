#!/bin/zsh


########################################################################
##########################   INJECT LOGGER   ###########################
########################################################################
#                                                                      #
#                                                                      #
#               Simple Zsh utility to inject logging                   #
#                       into your scripts.                             #
#                                                                      #
#                                                                      #
#   INSTALLATION:                                                      #
#                                                                      #
#     Simply add `source "path/to/inject-logger.zsh"` to the top       #
#     of your script to enable logging. (Don't forget to put the       #
#     actual path to Inject Logger).                                   #
#                                                                      #
#                                                                      #
#   USAGE:  <command> [message]                                        #
#                                                                      #
#                                                                      #
#   COMMANDS:                                                          #
#                                                                      #
#      warn  -  Quick and dirty error logging, provides the filename   #
#               and the line-number whence it was called.              #
#                 Log-level: 1                                         #
#                                                                      #
#     state  -  States the filename and your log message. That's it.   #
#                 Log-level: 2                                         #
#                                                                      #
#     debug  -  More verbose logging; gives the source of the          #
#               statement, including the line-number.                  #
#                 Log-level: 3                                         #
#                                                                      #
#     stack  -  Dumps a stack-trace up to the point where `stack`      #
#               was called. Useful for tracking entry into a script.   #
#                 Log-level: 3                                         #
#                                                                      #
#                                                                      #
#   CONFIGURATION:                                                     #
#                                                                      #
#      log_source [title]                                              #
#                                                                      #
#          Manually override filename used for any log actions.        #
#                                                                      #
#          DEFAULT VALUE: contents of $0                               #
#                                                                      #
#                                                                      #
#      log_level [level]                                               #
#                                                                      #
#          Sets the level at which the current log_source should be    #
#          logging. You can find the relative "log-level" threshold    #
#          for each logging command above. Commands with a threshold   #
#          above the currently configured level will not trigger.      #
#                                                                      #
#          DEFAULT VALUE: "1"                                          #
#                                                                      #
#          NAMED VALUES:                                               #
#             1 - "warn", "error"                                      #
#             2 - "state", "log"                                       #
#             3 - "debug", "stack"                                     #
#                                                                      #
#                                                                      #
#      Colors Settings:                                                #
#                                                                      #
#          You can also set the color of any log type by settings any  #
#          of the follow control variables using ANSI color codes      #
#          (values shown are the defaults):                            #
#                                                                      #
#          LOG_COLOR_RESET='\033[0m'                                   #
#          LOG_WARN_COLOR='\033[38;5;124m'                             #
#          LOG_STATE_COLOR='\033[0m'                                   #
#          LOG_DEBUG_COLOR='\033[38;5;34m'                             #
#          LOG_STACK_COLOR='\033[38;5;140m'                            #
#                                                                      #
########################################################################


zmodload "zsh/parameter" 

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

export LOG_COLOR_RESET='\033[0m'
export LOG_WARN_COLOR='\033[38;5;124m'
export LOG_STATE_COLOR='\033[0m'
export LOG_DEBUG_COLOR='\033[38;5;34m'
export LOG_STACK_COLOR='\033[38;5;140m'
warn  () { [[ `log_level` -gt 0 ]] && echo "${LOG_WARN_COLOR}[$(log_source)] $@${LOG_COLOR_RESET}" >&2 || return 1 }
state () { [[ `log_level` -gt 1 ]] && echo "${LOG_STATE_COLOR}[$(basename "${$(log_source)%%:*}")] $@${LOG_COLOR_RESET}" >&2 || return 1 }
debug () { [[ `log_level` -gt 2 ]] && echo "${LOG_DEBUG_COLOR}[${$(log_source)%%:*}$([ -n "${funcstack[2]}" ] && echo "::${funcstack[2]}"):${funcfiletrace[1]##*:}] $@${LOG_COLOR_RESET}" >&2 || return 1 }
stack () { [[ `log_level` -gt 2 ]] && echo "${LOG_STACK_COLOR}> ${funcfiletrace[1]}$([[ $# -gt 0 ]] && echo " >> \"$@\"")\n  ${(j:\n  :)funcfiletrace[@]:1:-1}${LOG_COLOR_RESET}" >&2 || return 1 }

