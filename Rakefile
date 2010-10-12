# -*-ruby-*-

require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new() {|i|
  i.name = "bwkfanboy"
  i.summary = 'A converter from HTML to Atom feed that you can use to watch sites that do not provide its own feed.'
  i.version = '0.1.2'
  i.author = 'Alexander Gromnitsky'
  i.email = 'alexander.gromnitsky@gmail.com'
  i.homepage = 'http://github.com/gromnitsky/bwkfanboy'
  i.platform = Gem::Platform::RUBY
  i.required_ruby_version = '>= 1.9'
  i.files = FileList['lib/**/*', 'bin/*', 'doc/*', '[A-Z]*', 'test/**/*']

  i.executables = FileList['bin/*'].gsub(/^bin\//, '')
  i.default_executable = i.name
  
  i.test_files = FileList['test/test_*.rb']
  
  i.rdoc_options << '-m' << 'Bwkfanboy' << '-x' << 'plugins'
  i.extra_rdoc_files = FileList['bin/*', 'doc/*']
  
  i.add_dependency('activesupport', '>= 3.0.0')
  i.add_dependency('nokogiri', '>=  1.4.3')
  i.add_dependency('open4', '>=  1.0.1')
  i.add_dependency('jsonschema', '>= 2.0.0')
}

Rake::GemPackageTask.new(spec).define()

task(default: %(repackage))

Rake::RDocTask.new('doc') {|i|
  i.main = "Bwkfanboy"
  i.rdoc_files = FileList['doc/*', 'lib/**/*.rb', 'bin/*']
  i.rdoc_files.exclude("lib/**/plugins", "test")
}

Rake::TestTask.new() {|i|
  i.test_files = FileList['test/test_*.rb']
  i.verbose = true
}
