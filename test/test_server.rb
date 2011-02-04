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
    assert_equal('64186fac2c52e5a969ad5675b9cc95ed', Digest::MD5.hexdigest(r))

    r = ''
    open("http://#{ADDR}:#{@port}/?p=quora&o=foo") { |f| r = f.read }
    # bin/bwkfanboy_server -Dd
    # wget -q -O - '127.0.0.1:9042/\?p=quora&o=foo' | md5
    assert_equal('f4cdeabd81a587afff91c91cb637f0b1', Digest::MD5.hexdigest(r))
  end
end
