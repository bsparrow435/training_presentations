# Links and Link Walking

Create several person objects

        for n in dan joe ian
        do
          curl -XPUT http://localhost:8098/riak/person/$n \
            -H 'content-type: text/plain' -d $n
        done

Create group objects linking to the person objects

        curl -XPUT http://localhost:8098/riak/group/da \
          -H 'content-type: text/plain' -d 'da' \
          -H 'link: </riak/person/dan>; riaktag="person"' \
          -H 'link: </riak/person/ian>; riaktag="person"'
 
        curl -XPUT http://localhost:8098/riak/group/ps \
          -H 'content-type: text/plain' -d 'ps' \
          -H 'link: </riak/person/joe>; riaktag="person"'

For each group link walk to the person objects

        curl http://localhost:8098/riak/group/da/_,_,_
        
        curl http://localhost:8098/riak/group/ps/_,_,_

Use a MapReduce link phase to retrieve persons from many groups

        curl -XPOST http://localhost:8098/mapred \
          -H 'content-type: application/json' \
          -d '{"inputs":[["group", "da"], ["group", "ps"]],
               "query":[{"link":{"keep":false}},
                        {"map":{"language":"erlang",
                                "module":"riak_kv_mapreduce",
                                "function":"map_object_value"}}]}'
