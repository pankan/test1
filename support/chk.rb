#!/usr/local/bin/ruby -w 
# create.rb
require "mongo"
# client = Mysql::Client.new(:host => "localhost", :username => "root", :password => "pichathi", :database => "sampledb")
client2 = Mongo::Client.new
db = client2["sampledb"]
coll = db['example-collection']

# inserting documents
10.times { |i| coll.insert({ :count => i+1 }) }

# finding documents
puts "There are #{coll.count} total documents. Here they are:"
coll.find.each { |doc| puts doc.inspect }
# client.select_db("sampledb")
# client.query("CREATE TABLE url3( uid varchar(3), loc varchar(100))")
#client2.query("INSERT INTO url2 VALUES('00A', 'http://www.qburst.com/')")
