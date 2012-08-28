# Secondary Indexes

## Backend

Verify `storage_backend` is set to `riak_kv_eleveldb_backend` in `app.config`

## Groups

Create several person objects with group indexes

        for n in dan ian
        do
          curl -XPUT http://localhost:8098/riak/person/$n \
            -H 'content-type: text/plain' -d $n \
            -H 'x-riak-index-group_bin: da' \
            -H 'x-riak-index-group_bin: trainer'
        done

        for n in joe
        do
          curl -XPUT http://localhost:8098/riak/person/$n \
            -H 'content-type: text/plain' -d $n \
            -H 'x-riak-index-group_bin: ps' \
            -H 'x-riak-index-group_bin: trainer'
        done

Lookup all persons in the `trainer` group

        curl http://localhost:8098/buckets/person/index/group_bin/trainer

Lookup all persons in the `da` group

        curl http://localhost:8098/buckets/person/index/group_bin/da

Lookup all persons in the `ps` group

        curl http://localhost:8098/buckets/person/index/group_bin/ps

## MapReduce

Use MapReduce to find all persons in the `da` group

        curl -XPOST http://localhost:8098/mapred \
          -H 'content-type: application/json' \
          -d '{"inputs":{
                "bucket":"person",
                "index":"group_bin",
                "key":"da"},
               "query":[{"map":{"language":"erlang",
                                "module":"riak_kv_mapreduce",
                                "function":"map_object_value"}}]}'

## Range Queries

Update each person object with an `age_int` index

        curl -XPUT http://localhost:8098/riak/person/ian \
            -H 'content-type: text/plain' -d 'ian' \
            -H 'x-riak-index-group_bin: da' \
            -H 'x-riak-index-group_bin: trainer' \
            -H 'x-riak-index-age_int: 21'

        curl -XPUT http://localhost:8098/riak/person/dan \
            -H 'content-type: text/plain' -d 'dan' \
            -H 'x-riak-index-group_bin: da' \
            -H 'x-riak-index-group_bin: trainer' \
            -H 'x-riak-index-age_int: 29'

        curl -XPUT http://localhost:8098/riak/person/joe \
            -H 'content-type: text/plain' -d joe \
            -H 'x-riak-index-group_bin: ps' \
            -H 'x-riak-index-group_bin: trainer' \
            -H 'x-riak-index-age_int: 52'

Lookup persons whose age is in the range `20-30`

        curl http://localhost:8098/buckets/person/index/age_int/20/30

## $key

Lookup persons whose name is in the range `apple-jasmine`

        curl http://localhost:8098/buckets/person/index/\$key/apple/jasmine

## $bucket

List all persons using the `$bucket` index

        curl http://localhost:8098/buckets/person/index/\$bucket/_
