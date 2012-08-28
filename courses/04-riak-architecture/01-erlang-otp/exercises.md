# Riak Architecture - Erlang OTP

## Start a Process and Send it a Message

Open an Erlang REPL, start a process, and send it a message:


    Pid = spawn(fun() -> receive {"Hello", Sender} when is_pid(Sender) -> io:format("Hello, ~p~n", [Sender]) end end).
    Pid ! {"Hello", self()}.
