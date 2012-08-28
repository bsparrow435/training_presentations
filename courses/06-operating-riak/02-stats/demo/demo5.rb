#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

client = Riak::Client.new
bucket = client.bucket("test")

puts "demo5: Before"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"

# make siblings
bucket.allow_mult = true
values = ["", ""]
(0..2048).each do |i|
  values[0] += "B"
  values[1] += "C"
end
(0..1000).each do |i|
  object1 = bucket.get("LargeObj#{i}")
  object2 = bucket.get("LargeObj#{i}")
  object1.data = values[0]
  object1.store
  object2.data = values[1]
  object2.store
end

puts "demo5: After"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"

