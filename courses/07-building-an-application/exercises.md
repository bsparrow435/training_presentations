# Building an Application

Compile the `qa` application

        make

Start the `qa` application

        make start

## Not Logged In

Browse to a question

        Riak > Getting Started > Installing > Package Install

Answer the question

Refresh the browser

* Notice that the state of the question, "Done" vs. "Not Done", is not persisted
across browser refreshses

## Logged In

Click the `Login with Github` link and login

Browse to the same question

        Riak > Getting Started > Installing > Package Install

Answer the question

Refresh the browser

* Notice that the state of the question is now persisted

## Restart Application

Stop the application by pressing `CTRL-C` twice in the Erlang shell

Start the application

        make start

Click the `Login with Github` link and login

Browse to the same question

        Riak > Getting Started > Installing > Package Install

* Notice that the state of the question is no longer persisted

## Replace ETS with Riak

The current implementation uses ETS for storage. ETS is an in memory store which
is why the state is lost when restarting the application.

Replace the ETS implementation using Riak. The only module that you need to make
changes to is `qa_user.erl`.
