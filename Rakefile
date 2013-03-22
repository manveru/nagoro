require 'rake/clean'
require 'rubygems/package_task'
require 'time'
require 'date'

PROJECT_SPECS = Dir['spec/{nagoro,example}/**/*.rb']
PROJECT_MODULE = 'Nagoro'
PROJECT_VERSION = (ENV['VERSION'] || Date.today.strftime('%Y.%m.%d')).dup

GEMSPEC = Gem::Specification.new{|s|
  s.name         = 'nagoro'
  s.author       = "Michael 'manveru' Fellinger"
  s.summary      = "An extendible and fast templating engine in pure ruby."
  s.description  = "An extendible and fast templating engine in pure ruby."
  s.email        = 'm.fellinger@gmail.com'
  s.homepage     = 'http://github.com/manveru/nagoro'
  s.platform     = Gem::Platform::RUBY
  s.version      = PROJECT_VERSION
  s.files        = `git ls-files`.split("\n").sort
  s.has_rdoc     = true
  s.require_path = 'lib'
}

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:bacon]

CLEAN.include('')
