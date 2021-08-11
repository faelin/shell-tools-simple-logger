# Simple Logger
Lightweight Zsh utility to inject logging functionality into your scripts.



## INSTALLATION:
1. Clone this repo via `git clone https://github.com/faelin/shell-tools-simple-logger.zsh`
2. Source the `simple-logger.zsh` file near the top of your script, or load it as a zsh plugin, to enable logging. 



## USAGE:
### LOGGING COMMANDS:

#### `warn [message]`
Quick and dirty error logging, provides the filename and the line-number whence it was called.<br>
**Log-level: 1**

#### `state [message]`
States the filename and your log message. That's it.<br>
**Log-level: 2**

#### `debug [message]`
More verbose logging; gives the source of the statement, including the line-number.<br>
**Log-level: 3**

#### `stack [message]`
Dumps a stack-trace up to the point where `stack` was called. Useful for tracking entry into a script.<br>
**Log-level: 3**



### CONFIGURATION COMMANDS:
The following configuration values can be set in any script where you intend to generate logs. Configuration values must be set AFTER sourcing the simple-logger.zsh utility.

NOTE: these are configuration _commands_, not configuration _variables_.

#### `log_source [title]`
Manually override filename used for any log actions.

**DEFAULT VALUE:** contents of `$0` (source path)


#### `log_level [level]`
Sets the level at which the current log_source should be logging. You can find the relative "log-level" threshold for each logging command above. Commands with a threshold above the currently configured level will not trigger.

**DEFAULT VALUE:** `"0"` (no logging)

Named values can be used instead of numeric levels.

**NAMED VALUES:**

```
  1 - "error", "warn"
  2 - "state", "log"
  3 - "debug", "stack"
```


#### `log_destination [filepath]`
Sets an output file. All simple-logger output will be recorded in the indicated file (if one is set).

**DEFAULT VALUE:** unset



### COLOR SETTINGS:
You can also set the color of any log type by setting any of the follow control variables using ANSI color codes (default values are shown below):

```
  LOG_COLOR_RESET='\033[0m'
  LOG_WARN_COLOR='\033[38;5;124m'
  LOG_STATE_COLOR='\033[0m'
  LOG_DEBUG_COLOR='\033[38;5;34m'
  LOG_STACK_COLOR='\033[38;5;140m'
```

