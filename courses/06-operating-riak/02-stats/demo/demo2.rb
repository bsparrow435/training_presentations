#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

client = Riak::Client.new
bucket = client.bucket("test")

puts "demo2: Before"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"
(0..1000).each do |i|
  object = bucket.get("Obj#{i}")
end
puts "demo2: After"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"