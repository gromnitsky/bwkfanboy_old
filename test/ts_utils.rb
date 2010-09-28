# return the right directory for _c_
def cmd(c)
  @tpath = ''
  case File.basename(Dir.pwd)
  when 'bwkfanboy'
    # test probably is executed from the Rakefile
    @tpath = 'test/'
    'bin/' + c
  when 'test'
    # we are probably in the test directory
    '../bin/' + c
  else
    # tests were invoked by 'gem check -t bwkfanboy'
    begin
      Dir.chdir(Bwkfanboy::Utils.gem_dir_system + '/../../test')
      '../bin/' + c
    rescue
      raise "running tests from '#{Dir.pwd}' isn't supported: #{$!}"
    end
  end
end
