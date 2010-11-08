require 'open-uri'

require_relative 'utils'

module Bwkfanboy
  class Fetch

    # If no block given, return contents of fetch'ed URI. Otherwise,
    # execute the block with 1 parameter--stream.
    def self.cat(uri)
      uri.chomp!

      Bwkfanboy::Utils.veputs(1, "fetching #{uri}\n")

      begin
        open(uri, "User-Agent" => Bwkfanboy::Meta::USER_AGENT) {|f|
          if defined?(f.meta) && f.status[0] != '200' then
            Bwkfanboy::Utils.errx(1, "cannot fetch #{uri} : HTTP responce: #{f.status[0]}")
          end
          Bwkfanboy::Utils.veputs(1, "charset = #{f.content_type_parse[1][1]}\n") if defined?(f.meta)
          if block_given?
            yield f
          else
            return f.read
          end
        }
      rescue
        # typically Errno::ENOENT
        Bwkfanboy::Utils.errx(1, "cannot fetch: #{$!}");
      end

      return ""
    end

  end
end
