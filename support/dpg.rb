require 'pg'
require 'rexml/document'
require 'open-uri'

include REXML

class PostgresDirect
  # Create the connection instance.
  def connect
    @conn = PG.connect(
        :dbname => 'psampledb',
        :user => 'intern500')
  end

  # Create our test table (assumes it doesn't already exist)
  def createurlTable
    @conn.exec("CREATE TABLE urls (uid serial NOT NULL, loc character varying(255), CONSTRAINT urls_pkey PRIMARY KEY (uid)) WITH (OIDS=FALSE);");
  end

  # When we're done, we're going to drop our test table.


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

  # Get our data back
  def queryurlTable
    @conn.exec( "SELECT * FROM urls" ) do |result|
      result.each do |row|
        yield row if block_given?
      end
    end
  end

  # Disconnect the back-end connection.
  def disconnect
    @conn.close
  end
end

def main
  p = PostgresDirect.new()
  p.connect
  begin
    p.createurlTable
    p.prepareInserturlStatement
    
    i=1
#----------------------Parsing xml------------------------#

uri = URI.parse("http://www.qburst.com/sitemap.xml")

#---------------------Fetching data-----------------------#

uri.open {|f|
  xmldoc = Document.new(f)
  xmldoc.elements.each("urlset/url/loc"){ 
    |e|

    # Insert into MySQL DB
    # client.query("INSERT INTO url (uid,loc) VALUES ('#{ i }','#{ e.text }')")
    
    # Insert into Postgres DB
    p.addurl(i, "#{ e.text }")
    
    # Insert into MongoDB
    #

    i=i+1
  }
}



    # p.addurl(1, "http://www.qburst.com/")
    # p.queryurlTable {|row| printf("%d %s\n", row['uid'], row['name'])}
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    # p.dropurlTable
    p.disconnect
  end
end

main