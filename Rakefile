begin
  require 'rubygems'
rescue LoadError
end

require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'pp'
include FileUtils

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "lib")))

require 'nagoro/version'

AUTHOR = "manveru"
EMAIL = "m.fellinger@gmail.com"
DESCRIPTION = "An extendable templating engine in pure ruby"
HOMEPATH = 'http://nagoro.rubyforge.org'
BIN_FILES = %w( nagoro )
RDOC_FILES = %w[ lib ]
RDOC_OPTS = %w[
  --all
  --quiet
  --op rdoc
  --line-numbers
  --inline-source
  --title "Nagoro\ documentation"
  --exclude "^(_darcs|spec|pkg)/"
]


BASEDIR = File.expand_path(File.dirname(__FILE__))

NAME = "nagoro"
VERS = Nagoro::VERSION

task :spec do
  require 'lib/nagoro'

  Dir['spec/*/**/*.rb'].each do |file|
    load file
  end
end

task :default => :spec

GemSpec =
    Gem::Specification.new do |s|
      s.name = NAME
      s.version = VERS
      s.platform = Gem::Platform::RUBY
      s.has_rdoc = true
      s.extra_rdoc_files = RDOC_FILES
      s.rdoc_options += RDOC_OPTS
      s.summary = DESCRIPTION
      s.description = DESCRIPTION
      s.author = AUTHOR
      s.email = EMAIL
      s.homepage = HOMEPATH
      s.executables = BIN_FILES
      s.bindir = "bin"
      s.require_path = "lib"

      s.files = `git ls-files`.split("\n").sort
    end

Rake::GemPackageTask.new(GemSpec) do |p|
  p.need_tar = true
  p.gem_spec = GemSpec
end

desc "package and install ramaze"
task :install do
  name = "#{NAME}-#{VERS}.gem"
  sh %{rake package}
  sh %{sudo gem install pkg/#{name}}
end

desc "uninstall the ramaze gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

desc "Create an updated version of /#{NAME}.gemspec"
task :gemspec do
  gemspec = <<-OUT.strip
Gem::Specification.new do |s|
  s.name = %name%
  s.version = %version%

  s.summary = %summary%
  s.description = %description%
  s.platform = %platform%
  s.has_rdoc = %has_rdoc%
  s.author = %author%
  s.email = %email%
  s.homepage = %homepage%
  s.executables = %executables%
  s.bindir = %bindir%
  s.require_path = %require_path%

  s.files = %files%
end
  OUT

  gemspec.gsub!(/%(\w+)%/) do
    case key = $1
    when 'version'
      GemSpec.version.to_s.dump
    else
      GemSpec.send(key).pretty_inspect.strip
    end
  end

  File.open("#{NAME}.gemspec", 'w+'){|file| file.puts(gemspec) }
end
