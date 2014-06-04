#!/usr/bin/ruby -w

require 'rexml/document'
require 'open-uri'
include REXML

uri = URI.parse("http://www.qburst.com/sitemap.xml")
uri.open {|f|
	xmldoc = Document.new(f)
	xmldoc.elements.each("urlset/url/loc"){ 
		|e| puts "Location : " + e.text
	}
}