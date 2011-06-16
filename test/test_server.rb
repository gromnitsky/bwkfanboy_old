require 'open-uri'

require_relative 'helper'

$count = 1

# this tests will mess up logs and the pid file
class TestServer < MiniTest::Unit::TestCase
  PORT = 9042
  ADDR = '127.0.0.1'

  def setup
    @cmd = cmd('bwkfanboy_server')
    @port = PORT + $count
    @pid = spawn("#{@cmd} -D -p #{@port}")
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
    assert_raises(OpenURI::HTTPError) { open("http://#{ADDR}:#{@port}/?p=inc") }
  end

  def test_right_plugins
    plugins = {
      'bwk' => '64186fac2c52e5a969ad5675b9cc95ed',
      'econlib' => '11f6114a9ab54d6ec67a26cbd76f5260',
      'inc' => '13dae248c81dd6407ff327dd5575f8b5',
    }
    plugins.each {|k,v|
      r = ''
      open("http://#{ADDR}:#{@port}/?p=#{k}&o=foo") { |f| r = f.read }
      # wget -q -O - '127.0.0.1:9042/?p=inc&o=foo' | md5
      assert_equal(v, Digest::MD5.hexdigest(r))
    }
  end
end
