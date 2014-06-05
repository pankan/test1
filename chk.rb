#!/usr/local/bin/ruby -w 
# create.rb
require "mysql"
# client = Mysql::Client.new(:host => "localhost", :username => "root", :password => "pichathi", :database => "sampledb")
client = Mysql.new("localhost", "root", "pichathi", "sampledb")
# client.select_db("sampledb")
# client.query("CREATE TABLE url3( uid varchar(3), loc varchar(100))")
client.query("INSERT INTO url2 VALUES('00A', 'http://www.qburst.com/')")
