# Getting Started - Installing

## Preparation

The following steps should be performed before the class is delivered.

Install an appropriate version of Erlang; one that is capable of building the
latest version of Riak.

Clone and build (`make`) Riak from Github.

## Demo

### make rel

Run `make rel`.

Show the directory that is created: `rel/riak`.

Explain that `rel/riak` contains a completely self contained version of Riak
including its own copy of the Erlang runtime system.

### make stage

`make rel` is excellent for setting up a self contained version of Riak but it
can be annoying to continuously run `make rel` every time a code change is made.

To avoid having to rebuild the release, one can use `make stage`. This task
builds a release into `rel/riak` and symlinks all the Riak libraries to their
development version under `deps`.

Remove `rel/riak`.

Run `make stage`.

Show the symlinks under `rel/riak/lib`.

### make devrel

The `make devrel` tasks builds 4 Riak releases to simplify setting up a cluster on your local machine.

Run `make devrel`.

Show the directories created under `dev`.

### make stagedevrel

The `make stagedevrel` task also builds 4 Riak releases but symlinks the
libraries is the same fashion as `make stage`.

Remove `dev`.

Run `make stagedevrel`.

Show the symlinks under `dev/dev1/lib`.
