#!/usr/bin/env ruby19
# -*-ruby-*-

require 'minitest/autorun'
require 'digest/md5'

require_relative '../lib/bwkfanboy/utils'
require_relative 'ts_utils'

class TestGenerate < MiniTest::Unit::TestCase
  CMD = 'bwkfanboy_generate'
    
  def test_empty_input
    r = Bwkfanboy::Utils.cmd_run("echo '' | #{cmd CMD}")
    assert_equal(1, r[0])
    assert_match(/stdin had invalid JSON/, r[1])
  end
  
  def test_invalid_json
    r = Bwkfanboy::Utils.cmd_run("echo '{\"foo\" : \"bar\"}' | #{cmd CMD} --check")
    assert_equal(1, r[0])
    assert_match(/channel is missing and it is not optional/, r[1])
  end

  def test_right_json
    r = Bwkfanboy::Utils.cmd_run("#{cmd CMD} --check < #{@tpath}semis/bwk.json")
    assert_equal(0, r[0])
    # bin/bwkfanboy_generate < test/semis/bwk.json|md5
    assert_equal('d432f4c8cf1c97bea200a2b8fd338bf8', Digest::MD5.hexdigest(r[2]))
  end
end
