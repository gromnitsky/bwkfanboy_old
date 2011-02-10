require_relative 'helper'

# TODO add HTTP 404 check; drop connection from server during HTTP 200
# replay...
class TestFetch < MiniTest::Unit::TestCase
  CMD = cmd('bwkfanboy_fetch')

  def test_empty_url
    r = Utils.cmd_run("echo '' | #{CMD}")
    assert_equal(1, r[0])
    assert_match(/No such file or directory/, r[1])
  end

  def test_invalid_url
    r = Utils.cmd_run("echo 'http://invalid.hostname.qwerty' | #{CMD}")
    assert_equal(1, r[0])
    assert_match(/504 Host .+ lookup failed: Host not found/, r[1])
  end

  def test_local_file
    cmd CMD
    r = Utils.cmd_run("echo semis/bwk.html | #{CMD}")
    assert_equal(0, r[0])
    # MD5 (html/bwk.html) = c8259a358dd7261a79b226985d3e8753
    assert_equal(Digest::MD5.hexdigest(r[2]), '00cc906c59c0eb11c3eaa8166dab729f')
  end
  
end
