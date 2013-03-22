# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nagoro"
  s.version = "2013.03"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael 'manveru' Fellinger"]
  s.date = "2013-03-22"
  s.description = "An extendible and fast templating engine in pure ruby."
  s.email = "m.fellinger@gmail.com"
  s.files = ["CHANGELOG", "MANIFEST", "README.markdown", "Rakefile", "bin/nagoro", "doc/COPYING", "doc/GPL", "doc/LEGAL", "example/element/Html.nage", "example/hello.nag", "example/morpher.nag", "lib/nagoro.rb", "lib/nagoro/binding.rb", "lib/nagoro/element.rb", "lib/nagoro/pipe.rb", "lib/nagoro/pipe/base.rb", "lib/nagoro/pipe/compile.rb", "lib/nagoro/pipe/element.rb", "lib/nagoro/pipe/include.rb", "lib/nagoro/pipe/instruction.rb", "lib/nagoro/pipe/localization.rb", "lib/nagoro/pipe/morph.rb", "lib/nagoro/pipe/tidy.rb", "lib/nagoro/scanner.rb", "lib/nagoro/template.rb", "lib/nagoro/tidy.rb", "lib/nagoro/version.rb", "nagoro.gemspec", "spec/core_extensions.rb", "spec/example/hello.rb", "spec/helper.rb", "spec/nagoro/listener/base.rb", "spec/nagoro/pipe/compile.rb", "spec/nagoro/pipe/element.rb", "spec/nagoro/pipe/include.rb", "spec/nagoro/pipe/instruction.rb", "spec/nagoro/pipe/morph.rb", "spec/nagoro/pipe/tidy.rb", "spec/nagoro/template.rb", "spec/nagoro/template/full.nag", "spec/nagoro/template/hello.nag", "tasks/authors.rake", "tasks/bacon.rake", "tasks/changelog.rake", "tasks/gem.rake", "tasks/manifest.rake", "tasks/rcov.rake", "tasks/release.rake", "tasks/reversion.rake"]
  s.homepage = "http://github.com/manveru/nagoro"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "An extendible and fast templating engine in pure ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
