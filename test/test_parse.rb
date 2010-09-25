#!/usr/bin/env ruby19
# -*-ruby-*-

require 'minitest/autorun'
require 'digest/md5'

require_relative '../lib/bwkfanboy/utils'
require_relative 'ts_utils'

class TestParse < MiniTest::Unit::TestCase
  CMD = 'bwkfanboy_parse'
    
  def test_no_plugin
    r = Bwkfanboy::Utils.cmd_run("#{cmd CMD} ''")
    assert_equal(1, r[0])
    assert_match(/cannot load plugin/, r[1])
  end

  def test_empty_plugin
    cmd CMD
    r = Bwkfanboy::Utils.cmd_run("#{cmd CMD} #{@tpath}plugins/empty.rb ")
    assert_equal(1, r[0])
    assert_match(/plugin .+ has errors: class Page isn't defined/, r[1])
  end

  def test_plugin_parse
    cmd CMD
    r = Bwkfanboy::Utils.cmd_run("#{cmd CMD} #{@tpath}plugins/bwk.rb < #{@tpath}semis/bwk.html")
    assert_equal(0, r[0])
    # bin/bwkfanboy_parse test/plugins/bwk.rb < test/semis/bwk.html | md5
    assert_equal('87127bb148b15e03adaee51f8ca839e2', Digest::MD5.hexdigest(r[2]))
  end
end
