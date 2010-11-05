#!/usr/bin/env ruby19

require 'minitest/autorun'
require 'open-uri'
require 'digest/md5'

require_relative 'ts_utils'

$count = 1

# this tests will mess up logs and the pid file
class TestServer < MiniTest::Unit::TestCase
  CMD = 'bwkfanboy_server'
  PORT = 9042
  ADDR = '127.0.0.1'

  def setup
    @port = PORT + $count
    @pid = spawn("#{cmd CMD} -D -p #{@port}")
    $count += 1
    sleep(2) # wait for the server's loading
  end

  def teardown
    Process.kill("TERM", @pid)
  end
  
  def test_no_plugin
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}") }
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}/?p=INVALID") }
    # 'o' is missing
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}/?p=quora") }
  end

  def test_right_plugin
    r = ''
    open("http://#{ADDR}:#{@port}/?p=bwk") { |f| r = f.read }
    # wget -q -O - 127.0.0.1:9042/\?p=bwk | md5
    assert_equal('c2116238d565aed57a2cc571cfc7faab', Digest::MD5.hexdigest(r))

    r = ''
    open("http://#{ADDR}:#{@port}/?p=quora&o=foo") { |f| r = f.read }
    # wget -q -O - '127.0.0.1:9042/\?p=quora&o=foo' | md5
    assert_equal('9f1824d0732c014901c8607d23549baa', Digest::MD5.hexdigest(r))
  end
end
