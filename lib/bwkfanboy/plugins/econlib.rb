# This is a skeleton for a bwkfanboy 1.3.0 plugin.  To understand how
# plugins work please read doc/plugins.rdoc file from bwkfanboy's
# distribution.

require 'nokogiri'

class Page < Bwkfanboy::Parse
  module Meta
    URI = 'http://www.econlib.org/cgi-bin/searcharticles.pl?sortby=DD&query=ha*'
    URI_DEBUG = '/home/alex/lib/software/alex/bwkfanboy/test/semis/econlib.html'
    ENC = 'UTF-8'
    VERSION = 1
    COPYRIGHT = "See bwkfanboy's LICENSE file"
    TITLE = "Latest articles from econlib.org"
    CONTENT_TYPE = 'html'
  end
  
  def myparse(stream)
    baseurl = 'http://www.econlib.org'
    
    # read 'stream' IO object and parse it
    doc = Nokogiri::HTML(stream, nil, Meta::ENC)
    doc.xpath("//*[@id='divResults']//tr").each {|i|
      t = clean(i.xpath("td[3]//a").text)
      next if t == ""
      l = baseurl + clean(i.xpath("td[3]//a")[0].attributes['href'].value)
      u = date(i.xpath("td[4]").children.text)
      a = clean(i.xpath("td[3]/div").children[2].text)
      c = clean(i.xpath("td[4]").children[2].text)

      self << { title: t, link: l, updated: u, author: a, content: c }
    }
  end
end
