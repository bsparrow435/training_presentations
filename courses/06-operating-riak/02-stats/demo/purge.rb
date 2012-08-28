#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'riak'

client = Riak::Client.new
bucket = client.bucket("test")

(0..1000).each do |i|
  object = bucket.get("Obj#{i}")
  object.delete
end
(0..1000).each do |i|
  object = bucket.get("LargeObj#{i}")
  object.delete
end