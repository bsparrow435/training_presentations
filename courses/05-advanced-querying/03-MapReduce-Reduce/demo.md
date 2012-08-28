# MapReduce - Reduce

The following demo builds off of the demo from the Map class. If you haven't 
done that demo you will need to set "allow_strfun" to "true" and load Riak with 
several "text/plain" objects.

    curl -XPUT http://localhost:8098/riak/docs/foo \
        -H 'Content-Type: text/plain' -d 'demo data goes here'
    curl -XPUT http://localhost:8098/riak/docs/bar \
        -H 'Content-Type: text/plain' -d 'demo demo demo demo'
    curl -XPUT http://localhost:8098/riak/docs/baz \
        -H 'Content-Type: text/plain' -d 'nothing to see here'
    curl -XPUT http://localhost:8098/riak/docs/qux \
        -H 'Content-Type: text/plain' -d 'demo demo'

Extend the MapReduce job demoed in the Map class to sort documents by word 
count.

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
                         end."}},
                {"reduce":{"language":"erlang",
                        "source":"fun(Values, _Arg) ->
                                F = fun([_,C1], [_,C2]) -> C2 =< C1 end,
                                lists:sort(F, Values)
                        end."}}]}'

Add a reduce phase that returns the second document.

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
                         end."}},
                {"reduce":{"language":"erlang",
                        "source":"fun(Values, _Arg) ->
                                F = fun([_,C1], [_,C2]) -> C2 =< C1 end,
                                lists:sort(F, Values)
                        end."}},
                {"reduce":{"language":"erlang",
                        "arg":{"reduce_phase_only_1": true,
                                "reduce_phase_batch_size": 3},
                        "source":"fun(Values, _Arg) ->
                                [lists:nth(2, Values)]
                        end."}}
                ]}'

Show indeterminate results when not using "reduce_phase_only_1".
