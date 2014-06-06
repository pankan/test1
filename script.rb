#!/usr/bin/ruby -w

require 'rexml/document'
require 'open-uri'
require 'mysql'
require 'pg'
require 'mongo'

include REXML
include Mongo

# MySQL

class MySQLDirect
	# 
	def connect
		@client = Mysql.new("localhost", "root", "pichathi", "parses")
	end
	def createurlTable
		@client.query("CREATE TABLE urls( uid varchar(3), loc varchar(255))")
	end

	def addurl(i,e)
		@client.query("INSERT INTO urls (uid,loc) VALUES ('#{ i }','#{ e.text }')")
	end
end


# PostgreSQL

class PostgresDirect
  # Create the connection instance.
  def connect
    @conn = PG.connect(
        :dbname => 'psampledb',
        :user => 'intern500'
    )
  end
  # Create table
  def createurlTable
    @conn.exec("CREATE TABLE urls (uid serial NOT NULL, loc character varying(255), CONSTRAINT urls_pkey PRIMARY KEY (uid)) WITH (OIDS=FALSE);");
  end

  # Prepared statements prevent SQL injection attacks.  However, for the connection, the prepared statements
  # live and apparently cannot be removed, at least not very easily.  There is apparently a significant
  # performance improvement using prepared statements.
  def prepareInserturlStatement
    @conn.prepare("insert_url", "insert into urls (uid, loc) values ($1, $2)")
  end

  # Add a url with the prepared statement.
  def addurl(uid, loc)
    @conn.exec_prepared("insert_url", [uid, loc])
  end
end


#MongoDB

db = Connection.new.db('nsampledb')
posts = db.collection('urls')


# Main function
def main

	i = 1 # ID token

	m = MySQLDirect.new
	m.connect
	m.createurlTable

	p = PostgresDirect.new()
  	p.connect
  	p.createurlTable
    p.prepareInserturlStatement

    # Parsing XML
	uri = URI.parse("http://www.qburst.com/sitemap.xml")

	# Saving to DBs
	uri.open {|f|
		xmldoc = Document.new(f)
		xmldoc.elements.each("urlset/url/loc"){ 
			|e|

			# Insert into MySQL DB
			m.addurl(i,e)
		
			# Insert into Postgres DB
			p.addurl(i, "#{ e.text }")
		
			# Insert into MongoDB
			new_post = { :loc => "#{ e.text }" }
      		post_id = posts.insert(new_post)

			i=i+1 # Update ID token
		}
	}
end
main