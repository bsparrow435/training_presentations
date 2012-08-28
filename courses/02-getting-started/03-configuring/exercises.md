# Getting Started - Configuring

## vm.args

### -name

1. Start Riak:

    riak start

2. Write an object to Riak using `riak-admin test`:

    riak-admin test

3. Stop Riak:

    riak stop

4. Open `etc/vm.args`.

5. Change `-name` to `RIAK@127.0.0.1`.

6. Save `etc/vm.args`.

7. Start Riak:

    riak start

8. Write an object to Riak using `riak-admin test`:

    riak-admin test

9. What happened?

10. Stop Riak:

    riak stop

11. User `riak-admin reip` to update the ring file:

    riak-admin reip riak@127.0.0.1 RIAK@127.0.0.1

12. Start Riak:

    riak start

13. Write an object to Riak using `riak-admin test`:

    riak-admin test

## app.config

### ring_creation_size

1. Start Riak:

    riak start

2. Write an object to Riak using `riak-admin test`:

    riak-admin test

3. Stop Riak:

    riak stop

4. Open `etc/app.config`:

5. Add `{ring_creation_size, 128}` to the `riak_core` section

6. Start Riak:

    riak start

7. Review the status of the Riak node:

    riak-admin status

8. What is the value of `ring_num_partitions`?

9. What is the value of `ring_creation_size`?

10. Why are they different?
