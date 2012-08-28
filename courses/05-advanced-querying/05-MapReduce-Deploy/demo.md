# MapReduce - Deploy

## Add a named Erlang function

Open `etc/vm.args`.

Add `-pa /tmp/funs` to the end of the file.

Make the directory `/tmp/funs`.

Create the file `/tmp/funs/foo.erl`.

Add the following to the file.

    -module(foo).
    -export([map/3]).
    map(_Object, _KeyData, _Arg) -> [<<"foo:map/3">>].

Compile the file to a beam.

    erlc foo.erl

Start Riak.

Use the custom function in a MapReduce query.

     curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":"docs",
              "query":[{"map":{
                "language":"erlang",
                "module":"foo",
                "function":"map"}}]}'

## Add a named JavaScript function

[Reference](https://github.com/basho/riak_kv/blob/master/priv/mapred_builtins.js)

Open `etc/app.config`.

Locate the `riak_kv` section.

Set the `js_source_dir` option to `/tmp/funs`.

Make the directory `/tmp/funs`.

Create the file `/tmp/funs/foo.js`.

Add the following to the file.

    var Foo = function() {
        return {
            map: function() { return ["Foo.map()"]; }
        };
    }();

Start Riak.

Use the custom function in a MapReduce query.

     curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":"docs",
              "query":[{"map":{
                "language":"javascript",
                "name":"Foo.map"}}]}'

