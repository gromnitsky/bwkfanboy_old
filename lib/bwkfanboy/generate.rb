require 'rss/maker'
require 'date'
require 'json'
require 'jsonschema'

require_relative 'utils'

module Bwkfanboy
  class Generate

    def self.validate(t)
      schema = Bwkfanboy::Utils.gem_dir_system() + '/schema.js'
      begin
        JSON::Schema.validate(t, JSON.parse(File.read(schema)))
      rescue
        Bwkfanboy::Utils.errx(1, "JSON validation with schema (#{schema}) failed");
      end
    end
    
    def self.atom(src)
      feed = RSS::Maker.make("atom") { |maker|
        maker.channel.id = src['channel']['id']
        maker.channel.updated = src['channel']['updated']
        maker.channel.author = src['channel']['author']
        maker.channel.title = src['channel']['title']
        
        maker.channel.links.new_link {|i|
          i.href = src['channel']['link']
          i.rel = 'alternate'
          i.type = 'text/html' # eh
        }
        
        maker.items.do_sort = true

        src['x_entries'].each { |i|
          maker.items.new_item do |item|
            item.links.new_link {|k|
              k.href = i['link']
              k.rel = 'alternate'
              k.type = 'text/html' # only to make happy crappy pr2nntp gateway
            }
            item.title = i['title']
            item.author = i['author']
            item.updated = i['updated']
            item.content.type = src['channel']['x_entries_content_type']
      
            case item.content.type
            when 'text'
              item.content.content = i['content']
            when 'html'
              item.content.content = i['content']
            else
              item.content.xhtml = i['content']
            end
          end
        }
      }

      return feed
    end
    
  end
end
