# Quora uses JavaScript to dynamically insert timestamps for the
# questions/comments. To combat this, we cut the JS from the page,
# evaluate it in nodejs and construct a hash with 'article-name =>
# timestamp' pairs.
#
# Tested with nodejs 0.2.3.
#
# Requires:
#
# - 'quora.js' script in directory with the plugin;
# - 1 option: a Quora user's name, for example 'Brandon-Smietana'

require 'nokogiri'

class Page < Bwkfanboy::Parse
  module Meta
    URI = 'http://www.quora.com/#{opt[0]}/answers'
    URI_DEBUG = '/home/alex/lib/software/alex/bwkfanboy/test/semis/quora.html'
    ENC = 'UTF-8'
    VERSION = 8
    COPYRIGHT = "See bwkfanboy's LICENSE file"
    TITLE = "Last n answers (per-user) from Quora; requires nodejs"
    CONTENT_TYPE = 'html'
  end
  
  def myparse(stream)
    profile = opt[0] # for example, 'Brandon-Smietana'
    
    # read stdin
    doc = Nokogiri::HTML(stream, nil, Meta::ENC)

    # extract & evaluate JavaScript into tstp
    tstp = nil
    doc.xpath("//script").each {|i|
      js = i.text
      if js.include?('"epoch_us"')
        if Bwkfanboy::Utils.cfg[:verbose] >= 3
          File.open("#{File.basename(__FILE__)}-epoch.js.raw", "w+") {|i| i.puts js }
        end
        r = Bwkfanboy::Utils.cmd_run("echo '#{js}' | #{File.dirname(__FILE__)}/quora.js")
        fail "evaluation in nodejs failed: #{r[1]}" if r[0] != 0
        tstp = JSON.parse(r[2])
        break
      end
    }

    # xpath movements
    url = 'http://www.quora.com'
    a = clean(doc.xpath("//h1").text())
      
    doc.xpath("//div[@class='feed_item_question']").each {|i|
      t = clean(i.xpath("h2").text())

      l = clean(i.xpath("h2//a")[0].attributes['href'].value())
      next unless tstp.key?(l)  # ignore answers without timestamps
      u = date(Time.at(tstp[l]/1000/1000).to_s)
#      u = DateTime.new.iso8601
      l = url + l + '/answer/' + profile
      
      c = i.xpath("../div[@class='hidden expanded_q_text']/div").inner_html(encoding: Meta::ENC)
      if c == ''
        c = i.xpath("../../div/div/div")
        c.xpath("div").each {|j| j.remove() }
        c = c.inner_html(encoding: Meta::ENC)
      end
      
      self << { title: t, link: l, updated: u, author: a, content: c }
    }
  end
end
