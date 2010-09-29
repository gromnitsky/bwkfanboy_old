# A simple plugin that parses the listing of bwk's articles from
# dailyprincetonian.com.

require 'nokogiri'

class Page < Bwkfanboy::Parse
  module Meta
    URI = 'http://www.dailyprincetonian.com/advanced_search/?author=Brian+Kernighan'
    URI_DEBUG = '/home/alex/lib/software/alex/bwkfanboy/test/semis/bwk.html'
    ENC = 'UTF-8'
    VERSION = 1
    COPYRIGHT = '(c) 2010 Alexander Gromnitsky'
    TITLE = "Brian Kernighan's articles from Daily Princetonian"
    CONTENT_TYPE = 'html'
  end
  
  def myparse()
    url = "http://www.dailyprincetonian.com"

    doc = Nokogiri::HTML(STDIN, nil, Meta::ENC)
    doc.xpath("//div[@class='article_item']").each {|i|
      t = clean(i.xpath("h2/a").children.text())
      fail 'unable to extract link' if (link = clean(i.xpath("h2/a")[0].attributes['href'].value()).empty?)
      link = clean(i.xpath("h2/a")[0].attributes['href'].value())
      l = url + link + "print"
      u = date(i.xpath("h2").children[1].text())
      a = clean(i.xpath("div/span/a[1]").children.text())
      c = clean(i.xpath("div[@class='summary']").text())
      
      self << { title: t, link: l, updated: u, author: a, content: c }
    }
  end
end
