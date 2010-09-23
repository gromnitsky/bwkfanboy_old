# $Id$

require 'json'
require 'date'

require_relative 'utils'

# :include: ../../doc/README.rdoc
module Bwkfanboy

  # :include: ../../doc/plugin.rdoc
  class Parse
    ENTRIES_MAX = 64
    
    def initialize()
      @entries = []
    end

    def parse()
      @entries = []
      begin
        myparse()
      rescue
        @entries = []
        Utils.errx(1, "parsing failed: #{$!}\n\nBacktrace:\n\n#{$!.backtrace.join("\n")}")
      end
      Utils.errx(1, "plugin return no output") if @entries.length == 0
    end

    def dump()
      @entries.each {|i|
        puts "title    : " + i[:title]
        puts "link     : " + i[:link]
        puts "updated  : " + i[:updated]
        puts "author   : " + i[:author]
        puts "content  : " + i[:content]
        puts ""
      }
    end
    
    def to_json()
      # guess the time of the most recent entry
      u = DateTime.parse() # January 1, 4713 BCE
      @entries.each {|i|
        t = DateTime.parse(i[:updated])
        u = t if t > u
      }
      
      m = get_meta()
      j = {
        channel: {
          updated: u,
          id: m::URI,
          author: Meta::NAME,   # just a placeholder
          title: m::TITLE,
          link: m::URI,
          x_entries_content_type: m::CONTENT_TYPE
        },
        x_entries: @entries
      }
      Utils::cfg[:verbose] >= 1 ? JSON.pretty_generate(j) : JSON.generate(j)
    end

    def check
      m = get_meta()
      begin
        [:URI, :ENC, :VERSION, :COPYRIGHT, :TITLE, :CONTENT_TYPE].each {|i|
          fail "#{m}::#{i} not defined or empty" if (! m.const_defined?(i) || m.const_get(i) =~ /^\s*$/)
        }
      rescue
        Utils.errx(1, "incomplete plugin: #{$!}")
      end
    end

    def dump_info()
      m = get_meta()
      puts "Version     : #{m::VERSION}"
      puts "Copyright   : #{m::COPYRIGHT}"
      puts "Title       : #{m::TITLE}"
      puts "URI         : #{m::URI}"
    end

    protected

    # This *must* be overridden in the child.
    def myparse()
      raise "plugin isn't finished yet"
    end
    
    def date(s)
      begin
        DateTime.parse(clean(s)).iso8601()
      rescue
        Utils.vewarnx(2, "#{s} is unparsable; date is set to current")
        DateTime.now().iso8601()
      end
    end

    def <<(t)
      if @entries.length >= ENTRIES_MAX then
        Utils.warnx("reached max number of entries (#{ENTRIES_MAX})")
        return @entries
      end
          
      %w(updated author).each { |i|
        fail "unable to extract '#{i}'" if ! t.key?(i.to_sym) || t[i.to_sym].empty?
      }
      %w(title link content).each { |i|
        fail "missing '#{i}'" if ! t.key?(i.to_sym)
      }
      # a redundant check if user hasn't redefined date() method
      if t[:updated] !~ /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}/ then
        fail "'#{t[:updated]}' isn't in iso8601 format"
      end
      @entries << t
    end

    private

    def clean(s)
      s.gsub(/\s+/, ' ').strip()
    end

    def get_meta()
      Utils.errx(1, "incomplete plugin: no #{self.class}::Meta module") if (! defined?(self.class::Meta) || ! self.class::Meta.is_a?(Module))
      self.class::Meta
    end
    
  end # class

end # module
