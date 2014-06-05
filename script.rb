#!/usr/bin/ruby -w

require 'rexml/document'
require 'open-uri'
require 'mysql'

include REXML

client = Mysql.new("localhost", "root", "pichathi", "parses")
client.query("CREATE TABLE url( uid varchar(3), loc varchar(100))")
i=0
uri = URI.parse("http://www.qburst.com/sitemap.xml")
uri.open {|f|
	xmldoc = Document.new(f)
	xmldoc.elements.each("urlset/url/loc"){ 
		 |e| client.query("INSERT INTO url (uid,loc) VALUES ('#{ i }','#{ e.text }')")
          i=i+1
	}
}