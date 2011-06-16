require_relative 'helper'

class TestGenerate < MiniTest::Unit::TestCase
  def setup
    @cmd = cmd('bwkfanboy_generate')
  end
    
  def test_empty_input
    r = Utils.cmd_run("echo '' | #{@cmd}")
    assert_equal(1, r[0])
    assert_match(/stdin had invalid JSON/, r[1])
  end
  
  def test_invalid_json
    r = Utils.cmd_run("echo '{\"foo\" : \"bar\"}' | #{@cmd} --check")
    assert_equal(1, r[0])
    assert_match(/channel:? is missing and it is not optional/, r[1])
  end

  def test_right_json
    r = Utils.cmd_run("#{@cmd} --check < semis/bwk.json")
    assert_equal(0, r[0])
    # bin/bwkfanboy_generate < test/semis/bwk.json|md5
    assert_equal('adc5a0d9487bdc11b6896fe29745ffa3', Digest::MD5.hexdigest(r[2]))
  end
end
