#!/usr/bin/env ruby19
# -*-ruby-*-

require 'cgi'
require_relative '../lib/bwkfanboy/parser'

# set this!
CONVERTER = '/home/alex/lib/software/example/ruby/bwkfanboy/bin/bwkfanboy'

def errx(t)
  print "Content-Type: text/plain\r\n\r\n"
  print "#{Bwkfanboy::Meta::NAME}.cgi error: #{t}"
  exit 0
end

cgi = CGI.new
if cgi.has_key?('p') then
  errx("invalid plugin name: #{cgi['p']}") if cgi['p'] !~ Bwkfanboy::Meta::PLUGIN_NAME
else
  errx("parametr 'p' required")
end

cmd = "#{CONVERTER} #{cgi['p']}"
r = Bwkfanboy::Utils.cmd_run(cmd)
errx("\n\n#{r[1]}") if r[0] != 0
xml = r[2]

print "Content-Type: application/atom+xml; charset=UTF-8\r\n"
print "Content-Length: #{xml.length}\r\n"
print "Content-Disposition: inline; filename=\"#{Bwkfanboy::Meta::NAME}-#{cgi['p']}.xml\"\r\n\r\n"

puts xml
