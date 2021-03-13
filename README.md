# INJECT LOGGER</h1>

Simple Zsh utility to inject logging into your scripts.


##   INSTALLATION:

Simply clone this repo and add `source "path/to/inject-logger.zsh"` to the top
of your script to enable logging. (Don't forget to put the
actual path to the Inject Logger repo!).

Now you can call log commands!


##   COMMANDS:

     usage:  <command> [message]
       
       warn   -  Quick and dirty error logging, provides the filename
                 and the line-number whence it was called.
                    Log-level: 1
       
       state  -  States the filename and your log message. That's it.
                    Log-level: 2
       
       debug  -  More verbose logging; gives the source of the
                 statement, including the line-number.
                    Log-level: 3
       
       stack  -  Dumps a stack-trace up to the point where `stack`
                 was called. Useful for tracking entry into a script.
                    Log-level: 3


##   CONFIGURATION:


      log_source [title]

          Manually override filename used for any log actions.

          DEFAULT VALUE: contents of $0


      log_level [level]

          Sets the level at which the current log_source should be
          logging. You can find the relative "log-level" threshold
          for each logging command above. Commands with a threshold
          above the currently configured level will not trigger.

          DEFAULT VALUE: "1"

          NAMED VALUES:
             1 - "warn", "error"
             2 - "state", "log"
             3 - "debug", "stack"

