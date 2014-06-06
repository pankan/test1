require 'mongo'
require 'rexml/document'
require 'open-uri'

include REXML
include Mongo

db = Connection.new.db('gsampledb')
posts = db.collection('urls')

uri = URI.parse("http://www.qburst.com/sitemap.xml")

  # Saving to DBs
  uri.open {|f|
    xmldoc = Document.new(f)
    xmldoc.elements.each("urlset/url/loc"){ 
      |e|

      # Insert into MySQL DB
      # m.addurl(i,e)
    
      # # Insert into Postgres DB
      # p.addurl(i, "#{ e.text }")
    
      # Insert into MongoDB
      new_post = { :loc => "#{ e.text }" }
      post_id = posts.insert(new_post)
      # i=i+1 # Update ID token
    }
  }



