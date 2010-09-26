#!/usr/bin/env ruby19
# -*-ruby-*-

require 'minitest/autorun'
require 'digest/md5'

require_relative '../lib/bwkfanboy/utils'
require_relative 'ts_utils.rb'

# TODO add HTTP 404 check; drop connection from server during HTTP 200
# replay...
class TestFetch < MiniTest::Unit::TestCase
  CMD = 'bwkfanboy_fetch'

  def test_empty_url
    r = Bwkfanboy::Utils.cmd_run("echo '' | #{cmd CMD}")
    assert_equal(1, r[0])
    assert_match(/No such file or directory/, r[1])
  end

  def test_invalid_url
    r = Bwkfanboy::Utils.cmd_run("echo 'http://invalid.hostname.qwerty' | #{cmd CMD}")
    assert_equal(1, r[0])
    assert_match(/504 Host .+ lookup failed: Host not found/, r[1])
  end

  def test_local_file
    cmd CMD
    r = Bwkfanboy::Utils.cmd_run("echo #{@tpath}semis/bwk.html | #{cmd CMD}")
    assert_equal(0, r[0])
    # MD5 (html/bwk.html) = c8259a358dd7261a79b226985d3e8753
    assert_equal(Digest::MD5.hexdigest(r[2]), 'c8259a358dd7261a79b226985d3e8753')
  end
  
end