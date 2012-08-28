# Demo Script #
* Start a cluster
* `bundle exec rake stats:demo1` PUTs 1000 small objects
* Look at the stats! Kill about a minute here.
* run the stats call: `riak-admin status | egrep "node_(put|get)"`
* Look at the stats! The _totals didn't change, but the per minute ones are back to 0
* run a script that only gets `bundle exec rake stats:demo2`, show how only that only gets are affected. GETs each object from `demo1`
* run a script that PUTs with larger objects `bundle exec rake stats:demo3`
* watch the latency and obj size go up. 
* run a script that GETs those objects `bundle exec rake stats:demo4`
* watch the latency and obj size go up. 
* run a script that creates siblings `bundle exec rake stats:demo5`
* run a script that GETs those objects `bundle exec rake stats:demo4`
* watch the latency/objsize/and siblings all go up