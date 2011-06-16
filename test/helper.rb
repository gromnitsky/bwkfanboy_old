require 'digest/md5'
require 'fileutils'
include FileUtils

require_relative '../lib/bwkfanboy/utils'
include Bwkfanboy

require 'minitest/autorun'

# Return the right directory for (probably executable) _c_.
def cmd(c)
  case File.basename(Dir.pwd)
  when Meta::NAME.downcase
    # test probably is executed from the Rakefile
    Dir.chdir('test')
    STDERR.puts('!!!!!!!!!!!!!! chdir to test ' + Dir.pwd)
  when 'test'
    # we are in the test directory, there is nothing special to do
  else
    # tests were invoked by 'gem check -t bwkfanboy'
    begin
      Dir.chdir(Utils.gem_dir_system + '/../../test')
    rescue
      raise "running tests from '#{Dir.pwd}' isn't supported: #{$!}"
    end
  end

  '../bin/' + c
end
