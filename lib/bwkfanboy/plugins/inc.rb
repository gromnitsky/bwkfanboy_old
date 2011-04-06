# Requires 1 option: an author's name, for example 'jason-fried'.

require 'nokogiri'

class Page < Bwkfanboy::Parse
  module Meta
    URI = 'http://www.inc.com/author/#{opt[0]}'
    URI_DEBUG = '/home/alex/lib/software/alex/bwkfanboy/test/semis/inc.html'
    ENC = 'UTF-8'
    VERSION = 1
    COPYRIGHT = 'See bwkfanboy\'s LICENSE file'
    TITLE = "Articles (per-user) from inc.com"
    CONTENT_TYPE = 'html'
  end
  
  def myparse(stream)
    profile = opt[0]
    
    # read 'stream' IO object and parse it
    doc = Nokogiri::HTML(stream, nil, Meta::ENC)
    doc.xpath("//div[@id='articleriver']/div/div").each {|i|
      t = clean(i.xpath("h3").text)
      l = clean(i.xpath("h3/a")[0].attributes['href'].value)
      
      next if (u = i.xpath("div[@class='byline']/span")).size == 0
      u = date(u.text)
      
      a = clean(i.xpath("div[@class='byline']/a").text)
      
      c = i.xpath("p[@class='summary']")
      c.xpath("a").remove
      c = c.inner_html(encoding: Meta::ENC)
      
      self << { title: t, link: l, updated: u, author: a, content: c }
    }
  end
end
