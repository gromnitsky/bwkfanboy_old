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
    raise 'run tests from the program\'s root directory or in the test directory'
  end
end
