#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

puts "demo1: Before"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"
# gets and puts
client = Riak::Client.new
bucket = client.bucket("test")
(0..1000).each do |i|
  object = bucket.get_or_new("Obj#{i}")
  object.data = "This is just test data"
  object.content_type = "text/plain"
  object.store
end
puts "demo1: After"
puts "--------------------------------------------"
puts `riak-admin status | egrep "node_(put|get)"`
puts "--------------------------------------------"