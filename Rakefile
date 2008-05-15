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
BIN_FILES = %w( )
RDOC_FILES = %w[ lib ]
DEPENDENCIES = {}
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

task 'run-spec' do
  Dir['spec/*/**/*.rb'].each do |file|
    ruby file
  end
end

desc "run rspec"
task :spec do
  engine = ENV['NAGORO_ENGINE']
  %w[stringscanner libxml rexml].each do |env|
    puts
    puts "Run specs for: #{env}".center(75)
    ENV['NAGORO_ENGINE'] = env
    sh("rake run-spec")
  end
  ENV['NAGORO_ENGINE'] = engine
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
        # s.bindir = "bin"
        s.require_path = "lib"
        # s.post_install_message = POST_INSTALL_MESSAGE

        # s.add_dependency('rake', '>=0.7.3')
        # s.add_dependency('rspec', '>=1.0.2')
        # s.add_dependency('rack', '>=0.2.0')
        # s.required_ruby_version = '>= 1.8.5'

        s.files = (RDOC_FILES + %w[Rakefile] + Dir["{spec,lib}/**/*"]).uniq

        # s.extensions = FileList["ext/**/extconf.rb"].to_a
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

  %dependencies%

  s.files = %files%
end
  OUT

  gemspec.gsub!(/%(\w+)%/) do
    case key = $1
    when 'version'
      GemSpec.version.to_s.dump
    when 'dependencies'
      DEPENDENCIES.map{|l, v|
        "s.add_dependency(%p, %p)" % [l, v]
      }.join("\n  ")
    else
      GemSpec.send($1).pretty_inspect.strip
    end
  end

  File.open("#{NAME}.gemspec", 'w+'){|file| file.puts(gemspec) }
end
