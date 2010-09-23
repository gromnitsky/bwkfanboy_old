# -*-ruby-*-

require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new {|i|
  i.name = "bwkfanboy"
  i.summary = 'A HTML to Atom feed converter that you can use to watch sites that do not provide its own feed'
  i.version = '0.0.1'
  i.author = 'Alexander Gromnitsky'
  i.email = 'alexander.gromnitsky@gmail.com'
  i.platform = Gem::Platform::RUBY
  i.required_ruby_version = '>= 1.9'
  i.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a

  exe = ['bwkfanboy']
  [ 'fetch', 'parse', 'generate'].each {|j| exe << "#{exe[0]}_#{j}" }
  i.executables = exe
  i.default_executable = exe[0]
  
  i.has_rdoc = true
  i.test_files = FileList['test/ts_*.rb'].to_a
  i.rdoc_options << '-m' << 'Bwkfanboy'
  
  i.add_dependency('activesupport', '>= 3.0.0')
  i.add_dependency('nokogiri', '>=  1.4.3')
  i.add_dependency('open4', '>=  1.0.1')
}

Rake::GemPackageTask.new(spec).define

task :default => %(repackage)

Rake::RDocTask.new('doc') {|i|
  i.main = "Bwkfanboy"
  i.rdoc_files.include('doc/*.rdoc', "lib/**/*.rb", "bin/*")
  i.rdoc_files.exclude("lib/plugins")
}

Rake::TestTask.new {|i|
  i.test_files = FileList['test/ts_*.rb']
  i.verbose = true
}
