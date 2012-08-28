# MapReduce - Deploy

## Deploy Erlang code

Convert the following anonymous function to a named function.

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

Use the named function to count the occurrence of the word `demo`.

## Deploy JavaScript code

Convert the anonymous JavaScript functions created in the JavaScript exercises 
to named functions.

Count, sort, and page using the named JavaScript functions.
