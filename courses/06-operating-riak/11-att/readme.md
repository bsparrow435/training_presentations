# AT&T Silver Lining Reference #

## Deployment Overview (Riak EDS, Riak CS, HAProxy, stud, nagios) ##

Each storage node runs four services: stud, Riak CS, HAProxy and Riak EDS. We'll discuss them from the top down.

## DYNECT ##
DYNECT is used to resolve the following domains

** data.attstorage.com **
** *.data.attstorage.com **

**NOTE**: There

## Stud ##
Used to manage SSL certificates, and redirect traffic to HAProxy on port 8077. It is configured to listen on the external IP of the storage node on port 443.

## HAProxy ##
HAProxy listens port 8077 for connections from Stud. It then does IP White lists, and IPs that pass get forwarded on to Riak CS on port 8080

## Riak CS Overview ##
Riak CS is Basho's implementation of the S3 API. It is only accessible from the outside via Stud. 

## HAProxy Redux##
HAProxy is also used to load balance Riak EDS. Compute applications will access Riak via these HAProxy instances which load balance to Riak EDS nodes throughout the cluster. HAProxy listens on 10.0.0.0/8 interfaces on ports 8098 and 8087 which are the ports Riak traditionally listens on.

## Riak EDS ##
Riak EDS is running on each node, and listening on ports 8198 (HTTP) and 8187 (Protocol Buffers). It listens on the eth0, and all connections from the Compute layer come in via HAProxy

## Nagios (Riak related scripts) ##
[riak\_nagios GitHub repo](https://github.com/basho/riak_nagios)

Deployed to /usr/lib/riak\_nagios

`check_riak` is a shell script wrapper for available riak tests.

Nagios is also configured to fire an alert if any of the following processes are not running on a storage node: pound, epmd, haproxy, memsup, cpu\_sup, beam.smp, and run\_erl

### NPRE ###
Sample entries in `/etc/nagios/npre.cfg`

```
command[check_stud]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C stud 
command[check_epmd]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C epmd
command[check_haproxy]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C haproxy
command[check_memsup]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C memsup
command[check_cpu_sup]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C cpu_sup
command[check_beam.smp]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C beam.smp
command[check_run_erl]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C run_erl
command[check_riak_up]=/usr/lib/riak_nagios/check_riak up 
command[check_riak_end_to_end]=/usr/lib/riak_nagios/check_riak end_to_end localhost 8198 riak 
command[check_riak_repl_to_dfw1]=/usr/lib/riak_nagios/check_riak repl server san2-to-dfw1
command[check_riak_repl_from_dfw1]=/usr/lib/riak_nagios/check_riak repl client dfw1-to-san2
```


