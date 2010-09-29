require 'digest/md5'

class Page < Bwkfanboy::Parse
  module Meta
    URI = '/usr/ports/UPDATING'
    URI_DEBUG = URI
    ENC = 'ASCII'
    VERSION = 1
    COPYRIGHT = '(c) 2010 Alexander Gromnitsky'
    TITLE = "News from FreeBSD ports"
    CONTENT_TYPE = 'text'
  end

  def myadd(ready, t, l, u, a, c)
    return true if ! ready
    return false if toobig?
    self << { title: t, link: l, updated: u, author: a, content: c.rstrip } if ready
    return true
  end

  def clean(t)
    t = t[2..-1] if t[0] != "\t"
    return '' if t == nil
    return t
  end
  
  def myparse()
    re_u = /^(\d{8}):$/
    re_t1 = /^ {2}AFFECTS:\s+(.+)$/
    re_t2 = /^\s+(.+)$/
    re_a = /^ {2}AUTHOR:\s+(.+)$/

    ready = false
    mode = nil
    t = l = u = a = c = nil
    while line = STDIN.gets
      line.rstrip!

      if line =~ re_u then
        # add a new entry
        break if ! myadd(ready, t, l, u, a, c)
        ready = true
        u = date($1)
        l = $1                  # partial, see below
        t = a = c = nil
        next
      end

      if ready then
        if line =~ re_t1 then
          mode = 'title'
          t = $1
          c = clean($&) + "\n"
          # link should be unique
          l = "file://#{Meta::URI}\##{l}-#{Digest::MD5.hexdigest($1)}"
        elsif line =~ re_a
          mode = 'author'
          a = $1
          c += clean($&) + "\n"
        elsif line =~ re_t2 && mode == 'title'
          t += ' ' + $1
          c += clean($&) + "\n"
        else
          # content
          c += clean(line) + "\n"
          mode = nil
        end
      end

      # skipping the preamble
    end

    # add last entry
    myadd(ready, t, l, u, a, c)
  end
end
