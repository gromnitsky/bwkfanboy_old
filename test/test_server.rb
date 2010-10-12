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
    assert_equal('d547f81d2e05ff11713cd3b5472b161a', Digest::MD5.hexdigest(r))

    r = ''
    open("http://#{ADDR}:#{@port}/?p=quora&o=foo") { |f| r = f.read }
    # wget -q -O - '127.0.0.1:9042/\?p=quora&o=foo' | md5
    assert_equal('c431564d566ea25b5c7bf6417665c769', Digest::MD5.hexdigest(r))
  end
end
