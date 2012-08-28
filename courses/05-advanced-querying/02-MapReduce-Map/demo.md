# MapReduce - Map

Open "etc/app.config".

Scroll down to the "riak_kv" section.

Add "{allow_strfun, true}", and restart Riak.

Add several "text/plain" objects to Riak:

    curl -XPUT http://localhost:8098/riak/docs/foo \
	-H 'Content-Type: text/plain' -d 'demo data goes here'
    curl -XPUT http://localhost:8098/riak/docs/bar \
	-H 'Content-Type: text/plain' -d 'demo demo demo demo'
    curl -XPUT http://localhost:8098/riak/docs/baz \
	-H 'Content-Type: text/plain' -d 'nothing to see here'
    curl -XPUT http://localhost:8098/riak/docs/qux \
	-H 'Content-Type: text/plain' -d 'demo demo'

Count the occurrence of the word "demo" in every document in the "docs" bucket:

    curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":"docs",
              "query":[{"map":{"language":"erlang",
                "source":"fun(Object, _KD, _A) ->
                           Key = riak_object:key(Object),
                           Value = riak_object:get_value(Object),
                           Value1 = binary_to_list(Value),
                           Count = case regexp:matches(Value1, \"demo\") of
                                {match, Matches} -> length(Matches);
                                _ -> 0
                           end,
                           [[Key, Count]]
                         end."}}]}'

Update the MapReduce job to use an argument:

    curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":"docs",
              "query":[{"map":{"language":"erlang", "arg":"demo",
                "source":"fun(Object, _KD, A) ->
                           Key = riak_object:key(Object),
                           Value = riak_object:get_value(Object),
                           Value1 = binary_to_list(Value),
                           A1 = binary_to_list(A),
                           Count = case regexp:matches(Value1, A1) of
                                {match, Matches} -> length(Matches);
                                _ -> 0
                           end,
                           [[Key, Count]]
                         end."}}]}'

Update the MapReduce job to just query the "foo", "bar", "baz" docs:

    curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":[["docs", "foo"],["docs", "bar"],["docs", "baz"]],
              "query":[{"map":{"language":"erlang", "arg":"demo",
                "source":"fun(Object, _KD, A) ->
                           Key = riak_object:key(Object),
                           Value = riak_object:get_value(Object),
                           Value1 = binary_to_list(Value),
                           A1 = binary_to_list(A),
                           Count = case regexp:matches(Value1, A1) of
                                {match, Matches} -> length(Matches);
                                _ -> 0
                           end,
                           [[Key, Count]]
                         end."}}]}'

Update the MapReduce job to use keydata:

    curl -XPOST http://localhost:8098/mapred \
         -H 'Content-Type: application/json' \
         -d '{"inputs":[["docs", "foo", "data"],
                        ["docs", "bar", "here"],
                        ["docs", "baz", "nothing"]],
              "query":[{"map":{"language":"erlang",
                "source":"fun(Object, KD, _A) ->
                           Key = riak_object:key(Object),
                           Value = riak_object:get_value(Object),
                           Value1 = binary_to_list(Value),
                           KD1 = binary_to_list(KD),
                           Count = case regexp:matches(Value1, KD1) of
                                {match, Matches} -> length(Matches);
                                _ -> 0
                           end,
                           [[Key, KD, Count]]
                         end."}}]}'
