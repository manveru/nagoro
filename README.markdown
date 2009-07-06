           Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
  All files in this distribution are subject to the terms of the Ruby license.

# About Nagoro

Nagoro is a templating engine for HTML and XML, consequently also for XHTML.

Nagoro consists of a series of so-called pipes to produce valid ruby from the
templates that are eventually evaluated with custom binding.

All functionality of Nagoro is carefully tested by a series of specs to avoid
breakage and give a good overview of Nagoro's capabilities.

Parsing is done by a fine-tuned StringScanner that avoids actually checking
validity of the documents, this way you can use Ruby interpolation without
having to enclose it into CDATA sections.

# Features Overview

* Pipes

  Pipes are pluggable subclasses of `Nagoro::Pipe::Base` or respond to `::process`
  and the returned value should provide a `#to_html` method.

  * Element

    Elements are tags that correspond to classes.

  * Include

    Transforms `<include href="file" />` tags, file is passed to `Kernel::open` and
    so you can even include remote locations if you `require 'open-uri'`

  * Instruction

    Instructions have a syntax of `<?name instruction?>`, most common is
    `<?r code ?>` to evaluate ruby code without outputting it.

  * Localization

    Not based on Pipe::Base, processes the template by a regular expression and
    substitutes keys with localized strings.

  * Morph

    Custom tag parameters like `<div if="cond">condition is fulfilled</div>`

* Nagoro::Scanner

  A hand-rolled SaX style parser for templates using StringScanner.
  StringScanner is a part of Ruby standard library that provides lexical
  scanning operations on a String.
  It is mostly implemented in C, which makes it quite fast and efficient.
  Our implementation is not a strict XML/SGML parser and allows for arbitrary
  code inside the templates.


# Installation


* Rubygems

  The easiest way of installing Nagoro is by:

      $ gem install nagoro

  Make sure you have the necessary privileges to execute the command.
  Rubygems can be found at http://rubygems.org

* Git

  To get the latest version of nagoro, you can just pull from the repository
  and use it this way.

        $ git clone git://github.com/manveru/nagoro

  Please read the `man darcs` or `darcs help` for more information about
  updating and creating your own patches.
  This is usually only needed for developers as the implementation of nagoro is
  not rapidly changing and releases are made after every major change.

  Some hints for the usage of the git repo

  * Use `require 'nagoro'` from anywhere

    Add a file to your `site_ruby` named `nagoro.rb`
    the content should be:

          require '/path/to/git/repo/nagoro/lib/nagoro'

  * Get the latest version (from inside the nagoro directory)

          $ git pull

  * Recording a patch

          $ git commit -a

  * output your patches into a bundle ready to be mailed (compress it before
    sending to make sure it arrives in the way you sent it)

          $ git format-patch origin/HEAD
          $ tar -cjf ramaze_bundle.tar.bz2 *.patch


# Getting started

See the installation section for how to install nagoro.
After installation you can use nagoro in a couple of ways

## CLI

  From commandline using the `nagoro` executable.

        $ nagoro yourfile.xhtml

## In Ruby

### Compiling a template

Template compilation is useful if you have templates that have contents that
will not change for some time, it will only run it through the pipes once and
do an eval on the compiled string every time you call the `Template#result` or
`Template#tidy_result` methods on the returned Template instance.

    template = Nagoro.compile('<?r a = 42 ?>#{a * 42}')
    puts template.result
    puts '', 'And now tidy', ''
    puts template.tidy_result

### Rendering a template

This is handy for one-off scripts that just want to render without caring about
the compilation step.

    result = Nagoro.render('<?r a = 42 ?>#{a * 42}')
    puts result

You may also use the equivalent of the `Template#tidy_result` for rendering, that is done just as easily.

    result = Nagoro.tidy_render('<?r a = 42 ?>#{a * 42}')
    puts result

### Using a path instead of a String

Nagoro will try to find a file matching your argument. It's not very smart
about this functionality and will only try to determine whether your argument
exists on the filesystem if the string is smaller than 1024 characters, that's
mostly done for performance reasons.

    template = Nagoro.compile('yourfile.nag')
    puts template.result

And of course the same works for `Nagoro::render`.

    puts Nagoro.render('yourfile.nag')

# Examples

Examples can be found in the /example directory.


# Future plans

## Various backends

Using Nokogiri, Hpricot, REXML, or libxml-ruby as backends for Nagoro.

I actually implemented backends in REXML and libxml-ruby in previous versions
of Nagoro, but their insistence on well-formed markup made them unsuitable for
the style of interpolation required.

As a quick example, given a document that contains `<h1>#{1 < 10}</h1>`.

Nokogiri would produce `<h1>#{1</h1>` in HTML mode. In XML mode it will produce
`<h1>#{1  10}</h1>`. Both are useless interpretations of the document.

The libxml-ruby binding doesn't allow for relaxed parsing, and will fail to
parse. Since it's just a thin binding, there is no way to monkeypatch the
underlying parser, while it might still be possible to achieve something
similar using FFI or DL, the way that Nokogiri parses leaves me little hope
that I could actually bend it to my will.

REXML usually fails as well, and the monkeypatching required to make it parse
the input document would far exceed the amount of code required for our custom
parser, not to mention that the speed of REXML would still be very hard to
tolerate, the only argument for it seems to be that it's in stdlib.

Hpricot on the other hand doesn't provide a SaX API, and so isn't suited very
well to the pipe style of Nagoro, but is still the best candidate as it will
parse Nagoro documents correctly (in most cases).

That's just a quick run-down, I spent almost 2 weeks banging my head against
REXML and libxml-ruby.
The reason I avoided Hpricot is that I don't want to have a full Node
representation in memory, it's already questionable if having the whole
document as a String in memory is a good design choice.

## Stream parsing

This is impossible with StringScanner, it is hard-wired to check that you
actually give it a String (in C via the StringValue macro).
It would be possible with real SaX parser, but due to their limitations pointed
out above, we cannot use them.

An option would be to implement a parser in pure Ruby.
I will leave that to other people, the documents I process fit comfortably into
memory, and if you are processing larger documents, you will most likely have
to utilize something like XSLT.


# And thanks to...

This list is by no means a full listing of all these people, but I try to
get a good coverage despite that.

* Yukihiro Matsumoto a.k.a. matz

  For giving the world Ruby and bringing joy and passion back into programming.

* Jim Weirich

  For Rake, which lifts off a lot of tasks from the shoulders of every
  developer using it.

* George Moschovitis a.k.a. gmosx

  For the Nitro web framework. Its templating engine has been the inspiration
  for Nagoro.

* Jonathan Buch a.k.a. Kashia

  For the first implementation of the Localization mechanism which is mostly
  ported from Ramaze.

* Minero Aoki

  For his excellent StringScanner that works behind the scene, I've used it
  countless times and was always impressed by the way it makes even the most
  complex parsing seem trivial. Having it in the Ruby standard library and on
  all platforms is a significant bonus as well.
