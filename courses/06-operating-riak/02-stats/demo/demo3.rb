#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

client = Riak::Client.new
bucket = client.bucket("test")

puts "demo3: Before"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"
# get/put larger objects
value = ""
(0..2048).each {|i| value += "A"}
(0..1000).each do |i|
  object = bucket.get_or_new("LargeObj#{i}")
  object.data = value
  object.content_type = "text/plain"
  object.store
end
puts "demo3: After"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"