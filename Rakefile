require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'time'
require 'date'

PROJECT_SPECS = Dir['spec/{nagoro,example}/**/*.rb']
PROJECT_MODULE = 'Nagoro'

GEMSPEC = Gem::Specification.new{|s|
  s.name         = 'nagoro'
  s.author       = "Michael 'manveru' Fellinger"
  s.summary      = "An extendible and fast templating engine in pure ruby."
  s.description  = "An extendible and fast templating engine in pure ruby."
  s.email        = 'm.fellinger@gmail.com'
  s.homepage     = 'http://github.com/manveru/nagoro'
  s.platform     = Gem::Platform::RUBY
  s.version      = (ENV['PROJECT_VERSION'] || Date.today.strftime("%Y.%m.%d"))
  s.files        = `git ls-files`.split("\n").sort
  s.has_rdoc     = true
  s.require_path = 'lib'
}

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:bacon]

CLEAN.include('')
