#!/usr/bin/env ruby19
# -*-ruby-*-

require 'minitest/unit'
require 'minitest/autorun'
require 'open-uri'
require 'digest/md5'

require_relative 'ts_utils'

$count = 0

class TestServer < MiniTest::Unit::TestCase
  CMD = 'bwkfanboy_server'
  PORT = 9042
  ADDR = '127.0.0.1'

  def setup
    @port = PORT + $count
    @pid = spawn("#{cmd CMD} -p #{@port}")
    $count += 1
    sleep(2) # wait for the server's loading
  end

  def teardown
    Process.kill("TERM", @pid)
  end
  
  def test_no_plugin
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}") }
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}/?p=INVALID") }
  end

  def test_right_plugin
    r = ''
    open("http://#{ADDR}:#{@port}/?p=bwk") { |f| r = f.read }
    # wget -q -O - 127.0.0.1:9042/\?p=bwk | md5
    assert_equal('5c650552451adad2d607b53e332c8fda', Digest::MD5.hexdigest(r))
  end
end
