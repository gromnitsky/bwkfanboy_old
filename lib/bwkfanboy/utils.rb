require 'optparse'
require 'logger'

require 'open4'
require 'active_support/core_ext/module/attribute_accessors'

module Bwkfanboy
  module Meta
    NAME = 'bwkfanboy'
    VERSION = '0.1.1'
    USER_AGENT = "#{NAME}/#{VERSION} (#{RUBY_PLATFORM}; N; #{Encoding.default_external.name}; #{RUBY_ENGINE}; rv:#{RUBY_VERSION}.#{RUBY_PATCHLEVEL})"
    PLUGIN_CLASS = 'Page'
    DIR_TMP = "/tmp/#{Meta::NAME}/#{ENV['USER']}"
    DIR_LOG = "#{DIR_TMP}/log"
    LOG_MAXSIZE = 64*1024
    PLUGIN_NAME = /^[ a-zA-Z0-9_-]+$/
    PLUGIN_OPTS = /^[ a-zA-Z'"0-9_-]+$/
  end
  
  module Utils
    mattr_accessor :cfg, :log

    self.cfg = Hash.new()
    cfg[:verbose] = 0
    cfg[:log] = "#{Meta::DIR_LOG}/general.log"

    def self.warnx(t)
      m = File.basename($0) +" warning: "+ t + "\n";
      $stderr.print(m);
      log.warn(m.chomp) if log
    end

    def self.errx(ec, t)
      m = File.basename($0) +" error: "+ t + "\n"
      $stderr.print(m);
      log.error(m.chomp) if log
      exit(ec)
    end

    def self.veputs(level, t)
      if cfg[:verbose] >= level then
#        p log
        log.info(t.chomp) if log
        print(t)
      end
    end

    def self.vewarnx(level, t)
      warnx(t) if cfg[:verbose] >= level
    end

    # Logs and pidfiles the other temporal stuff sits here
    def self.dir_tmp_create()
      if ! File.writable?(Meta::DIR_TMP) then
        begin
          t = '/'
          Meta::DIR_TMP.split('/')[1..-1].each {|i|
            t += i + '/'
            Dir.mkdir(t) if ! Dir.exists?(t)
          }
        rescue
          warnx("cannot create/open directory #{Meta::DIR_TMP} for writing")
        end
      end
    end
    
    def self.log_start()
      dir_tmp_create()
      begin
        Dir.mkdir(Meta::DIR_LOG) if ! File.writable?(Meta::DIR_LOG)
        log = Logger.new(cfg[:log], 2, Meta::LOG_MAXSIZE)
      rescue
        warnx("cannot open log #{cfg[:log]}");
        return nil
      end
      log.level = Logger::DEBUG
      log.datetime_format = "%H:%M:%S"
      log.info("#{$0} starting")
      log
    end
    self.log = log_start()
    
    # Loads (via <tt>require()</tt>) a Ruby code from _path_ (the full path to
    # the file). <em>class_name</em> is the name of the class to check
    # for existence after successful plugin loading.
    def self.plugin_load(path, class_name)
      begin
        require(path)
        # TODO get rid of eval()
        fail "class #{class_name} isn't defined" if (! eval("defined?#{class_name}") || ! eval(class_name).is_a?(Class) )
      rescue LoadError
        errx(1, "cannot load plugin '#{path}'");
      rescue Exception
        errx(1, "plugin '#{path}' has errors: #{$!}\n\nBacktrace:\n\n#{$!.backtrace.join("\n")}")
      end
    end

     # Get possible options for the parser.
    def self.plugin_opts(a)
      opt = a.size >= 2 ? a[1..-1] : ''
    end

    
    # Parses command line options. _arr_ is an array of options (usually
    # +ARGV+). _banner_ is a help string that describes what your
    # program does.
    #
    # If _o_ is non nil function parses _arr_ immediately, otherwise it
    # only creates +OptionParser+ object and return it (if _simple_ is
    # false). See <tt>bwkfanboy</tt> script for examples.
    def self.cl_parse(arr, banner, o = nil, simple = false)
      if ! o then 
        o = OptionParser.new
        o.banner = banner
        o.on('-v', 'Be more verbose.') { |i| Bwkfanboy::Utils.cfg[:verbose] += 1 }
        return o if ! simple
      end

      begin
        o.parse!(arr)
      rescue
        Bwkfanboy::Utils.errx(1, $!.to_s)
      end
    end

    # used in CGI and WEBrick examples
    def self.cmd_run(cmd)
      pid, stdin, stdout, stderr = Open4::popen4(cmd)
      ignored, status = Process::waitpid2(pid)
      [status.exitstatus, stderr.read, stdout.read]
    end

    def self.gem_dir_system
      t = ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}",
           "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
      t.each {|i| return i if File.readable?(i) }
      raise "both paths are invalid: #{t}"
    end
    
  end # utils
end
