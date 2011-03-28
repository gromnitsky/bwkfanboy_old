# -*-ruby-*-

require 'erb'
require 'json'
require 'pathname'

module MyDocs
  PATH = Pathname.new File.dirname(__FILE__)

  # our targets
  RDOC = FileList["#{PATH}/*.erb"].sub(/\.erb$/, '.rdoc')
  RDOC_RELATIVE = RDOC.pathmap '%-1d/%f'

  BWK = PATH.parent + 'bin/bwkfanboy'
  PLUGINS_DIR = PATH.parent + 'lib/bwkfanboy/plugins'
  PLUGINS = Dir["#{PLUGINS_DIR}/*.rb"].map {|i| i.pathmap '%{\.rb$}f' }

  # Return a list of plugins with description for each plugin.
  # This is used in .erb files.
  def self.plugins
    plugin_name_max = 20

    r = [format("%-#{plugin_name_max}s %s %s\n", 'NAME', 'VER', 'DESCRIPTION')]
    PLUGINS.each {|i|
      pr = `#{BWK} -i #{i} q w e r t y`.split("\n")
      ver = pr[0].split(':')[1..-1].join.strip
      desc = pr[2].split(':')[1..-1].join.strip
      r << format("%-#{plugin_name_max}s %3s %s", i, ver, desc)
    }
    r
  end
end

namespace 'mydocs' do
  rule '.rdoc' => ['.erb', MyDocs::PLUGINS_DIR.to_s] do |i|
    File.open(i.name, 'w+') {|fp|
      puts i.source.pathmap('%-1d/%f') + ' > ' + i.name.pathmap('%-1d/%f')
      fp.puts ERB.new(File.read(i.source)).result(binding)
    }
  end

  desc "Generate all"
  task :default => MyDocs::RDOC

  desc "Clean all crap"
  task :clean do
    rm(MyDocs::RDOC, verbose: true, force: true)
  end

  desc "Print a list of plugins"
  task :plugins do
    MyDocs.plugins.each {|i| puts i}
  end

  desc "Print all staff that _can_ be generated"
  task :print_gen do
    puts MyDocs::RDOC.to_a.to_json
  end
end
