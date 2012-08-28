# MapReduce - JavaScript

## Change the number of running JavaScript VMs

Run `riak console`.

Highlight the Spidermonkey VM log messages:

        20:36:55.722 [info] Spidermonkey VM (thread stack: 16MB, max heap: 8MB, pool: riak_kv_js_map) host starting (<0.314.0>)

Exit out of the console (`q().`).

Open `etc/app.config`.

Locate the `riak_kv` section.

Change `map_js_vm_count` to 1.

Change `reduce_js_vm_count` to 1.

Change `hook_js_vm_count` to 1.

Run `riak console`.

Highlight the Spidermonkey VM log messages:

        20:36:55.722 [info] Spidermonkey VM (thread stack: 16MB, max heap: 8MB, pool: riak_kv_js_map) host starting (<0.314.0>)

Note the reduced number of log messages.

Exit out of the console (`q().`).

Reset VM counts to their original values (`8`, `6`, `2`).

## Extract value, arg, and keydata

Add a `text/plain` object to Riak with the body `bar`.

Extract the value of the object using a JavaScript MapReduce job.

Add an `arg` to the phase and extract its value.

Add `keydata` to the inputs and extract its value.

## Count words

Add several `text/plain` objects to Riak.

Write a JavaScript MapReduce job to count the number of times a particular word 
appears in an object. A simple way to count words based on a regular expression 
in JavaScript:

        function(v, keyData, arg) { 
                var re = RegExp(arg, "gi");
                var m = v.values[0].data.match(re);
        }

## Sort results

Add a JavaScript reduce phase to the previous query to sort the results. Objects 
with the highest word count should be at the head of the list.

## Page results

Add another JavaScript reduce phase to return just the 2nd result.
