require_relative 'helper'

class TestParse < MiniTest::Unit::TestCase
  def setup
    @cmd = cmd('bwkfanboy_parse')
    @libdir = '../lib/bwkfanboy'
  end
    
  def test_no_plugin
    r = Utils.cmd_run("#{@cmd} ''")
    assert_equal(1, r[0])
    assert_match(/cannot load plugin/, r[1])
  end

  def test_empty_plugin
    r = Utils.cmd_run("#{@cmd} #{Dir.pwd}/plugins/empty.rb")
    assert_equal(1, r[0])
    assert_match(/plugin .+ has errors: class Page isn't defined/, r[1])
  end

  def test_plugin_parse
    r = Utils.cmd_run("#{@cmd} #{Dir.pwd}/#{@libdir}/plugins/bwk.rb < semis/bwk.html")
    assert_equal(0, r[0])
    # bin/bwkfanboy_parse `pwd`/lib/bwkfanboy/plugins/bwk.rb < test/semis/bwk.html | md5
    assert_equal('a433a4a27bafb060a41aa85a40808056', Digest::MD5.hexdigest(r[2]))
  end
end
