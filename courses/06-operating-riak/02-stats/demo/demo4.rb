#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

client = Riak::Client.new
bucket = client.bucket("test")

puts "demo4: Before"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"

# get/put larger objects
(0..1000).each do |i|
  object = bucket.get("LargeObj#{i}")
end
puts "demo4: After"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"