Gem::Specification.new do |s|
  s.name = "nagoro"
  s.version = "2009.03.21"

  s.summary = "An extendable templating engine in pure ruby"
  s.description = "An extendable templating engine in pure ruby"
  s.platform = "ruby"
  s.has_rdoc = true
  s.author = "manveru"
  s.email = "m.fellinger@gmail.com"
  s.homepage = "http://nagoro.rubyforge.org"
  s.executables = []
  s.bindir = "bin"
  s.require_path = "lib"

  s.files = ["README.markdown",
 "Rakefile",
 "bench.rb",
 "bin/nagoro",
 "doc/COPYING",
 "doc/GPL",
 "doc/LEGAL",
 "example/element/Html.nage",
 "example/hello.nag",
 "example/morpher.nag",
 "lib/nagoro.rb",
 "lib/nagoro/binding.rb",
 "lib/nagoro/element.rb",
 "lib/nagoro/pipe.rb",
 "lib/nagoro/pipe/base.rb",
 "lib/nagoro/pipe/compile.rb",
 "lib/nagoro/pipe/element.rb",
 "lib/nagoro/pipe/include.rb",
 "lib/nagoro/pipe/instruction.rb",
 "lib/nagoro/pipe/localization.rb",
 "lib/nagoro/pipe/morph.rb",
 "lib/nagoro/pipe/tidy.rb",
 "lib/nagoro/scanner.rb",
 "lib/nagoro/template.rb",
 "lib/nagoro/tidy.rb",
 "lib/nagoro/version.rb",
 "nagoro.gemspec",
 "spec/core_extensions.rb",
 "spec/example/hello.rb",
 "spec/helper.rb",
 "spec/nagoro/listener/base.rb",
 "spec/nagoro/pipe/compile.rb",
 "spec/nagoro/pipe/element.rb",
 "spec/nagoro/pipe/include.rb",
 "spec/nagoro/pipe/instruction.rb",
 "spec/nagoro/pipe/morph.rb",
 "spec/nagoro/pipe/tidy.rb",
 "spec/nagoro/template.rb",
 "spec/nagoro/template/full.nag",
 "spec/nagoro/template/hello.nag",
 "lib"]
end
