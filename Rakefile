# -*-ruby-*-

require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'
require 'json'

require_relative 'test/rake_git'

spec = Gem::Specification.new {|i|
  i.name = "bwkfanboy"
  i.summary = 'A converter from HTML to Atom feed that you can use to watch sites that do not provide its own feed.'
  i.description = i.summary
  i.version = `bin/#{i.name} -V`
  i.author = 'Alexander Gromnitsky'
  i.email = 'alexander.gromnitsky@gmail.com'
  i.homepage = "http://github.com/gromnitsky/#{i.name}"
  i.platform = Gem::Platform::RUBY
  i.required_ruby_version = '>= 1.9.2'
  i.files = git_ls('.')

  i.executables = FileList['bin/*'].gsub(/^bin\//, '')
  i.default_executable = i.name
  
  i.test_files = FileList['test/test_*.rb']
  
  i.rdoc_options << '-m' << 'doc/README.rdoc' << '-x' << 'plugins'
  i.extra_rdoc_files = FileList['doc/*.rdoc']
  
  i.add_dependency('open4', '>=  1.0.1')
  i.add_dependency('activesupport', '>= 3.0.3')
  i.add_dependency('nokogiri', '>=  1.4.4')
  i.add_dependency('jsonschema', '>= 2.0.0')

  i.add_development_dependency('git', '>= 1.2.5')
}

Rake::GemPackageTask.new(spec).define

task :mydocs do
  src = 'doc'
  
  IO.popen("cd #{src} && rake mydocs:default") {|fp|
    while line = fp.gets
      puts line
    end
  }
  
  # grab generated staff and add it to the spec
  IO.popen("cd #{src} && rake mydocs:print_gen") {|fp|
    json = nil
    while line = fp.gets
      json = line if line !~ /\(in /        # our JSON is in 1 line
    end
    
    if json
      r = JSON.parse(json)
      puts "Additional files for the spec: "
      r.map! {|i| "#{src}/" + i }
      r.each {|i| puts ' ' + i }
      spec.extra_rdoc_files.concat(r)
    end
  }
end

task default: [:mydocs, :repackage]

task doc: [:mydocs]

Rake::RDocTask.new('doc') do |i|
  i.main = 'doc/README.rdoc'
  i.rdoc_files = FileList['doc/*', 'lib/**/*.rb']
  i.rdoc_files.exclude("lib/**/plugins")
end

Rake::TestTask.new do |i|
  i.test_files = FileList['test/test_*.rb'] 
  i.libs << '.'
end
