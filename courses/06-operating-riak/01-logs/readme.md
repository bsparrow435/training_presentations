# Riak Logs Reference #

## Log Files ##
**console.log**: Info, Debug, Error log levels

**crash.log**: Detailed crash information

**erl_crash.dump**: The entire state of the Erlang VM at the time of VM crash.

**error.log**: Will note crashes, but not the details

**run\_erl.log**: Pretty much useless

## Content ##
Single line log entries

## Rotation ##
Traditional Log Rotation (console.log is always the newest, console.log.1 is next, etc...)