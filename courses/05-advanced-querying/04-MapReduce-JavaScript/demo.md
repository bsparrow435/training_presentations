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

Run `riak cnsole`.

Highlight the Spidermonkey VM log messages:

        20:36:55.722 [info] Spidermonkey VM (thread stack: 16MB, max heap: 8MB, pool: riak_kv_js_map) host starting (<0.314.0>)

Note the reduced number of log messages.

Exit out of the console (`q().`).
