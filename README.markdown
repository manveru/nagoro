           Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
  All files in this distribution are subject to the terms of the Ruby license.

# About Nagoro

Nagoro is a templating engine for XHTML based on different parsing engines.
It featues a modular code layout and is used in the Ramaze web framework.

Nagoro consists of a series of so-called pipes to produce valid ruby from the
templates that are eventually evaluated with custom binding.

All functionality of Nagoro is carefully tested by a series of specs to avoid
breakage and give a good overview of nagoros capabilities.

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

* Engines

  Nagoro utilizes different engines to accomplish template transformation,
  currently the "best" engine is hand-written using StringScanner.

  * StringScanner
  
    StringScanner is a part of Ruby standard library that provides lexical
    scanning operations on a String.
    It is mostly implemented in C, which makes it quite fast and efficient.
    Our implementation is not a strict XML/SGML parser and allows for arbitrary
    code inside the templates, this will be the engine you want to use most
    likely.

  * libxml-ruby
  
    These are the Ruby bindings for GNU/LibXML2, we are using the SaX2 interface.
    It should give you the best performance on large and standard conform
    documents, but it doesn't allow for arbitrary code inside the template as
    we have to feed it the document before doing any transformation or
    interpolation.

  * REXML

    REXML is a _pure_ Ruby, XML 1.0 conforming, non-validating toolkit with an
    intuitive API.  REXML passes 100% of the non-validating Oasis tests, and
    provides tree, stream, SAX2, pull, and lightweight APIs.  REXML also
    includes a full XPath 1.0 implementation.
    Since Ruby 1.8, REXML is included in the standard Ruby distribution.

    REXML was used for the first implementations of Nagoro, but for performance
    reasons libxml and StringScanner were introduced later on.
    It here is mostly to give a third example of how to wrap an engine or to
    give an idea of how a document would behave if it was fed into libxml as
    both are strict parsers.

    
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

* CLI

  From commandline using the `nagoro` executable.

        $ nagoro yourfile.xhtml

* In Ruby

  Using `Nagoro::render_file`

        nagoro = Nagoro.render_file('yourfile.xhtml')
        xhtml = nagoro.result(binding)
        puts xhtml

  Using Nagoro::render

        nagoro = Nagoro.render('<?r a = 42 ?>#{a * 42}')
        xhtml = nagoro.result(binding)
        puts xhtml

  Using Nagoro::render with filename, useful because it shows up in backtraces.

        nagoro = Nagoro.render('<?r a = 42 ?>#{a * 42}', :file => 'foo.xhtml')
        xhtml = nagoro.result(binding)
        puts xhtml

# Examples

Examples can be found in the /example directory.


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
  for nagoro.

* Johannes Buch a.k.a. Kashia

  For the first implementation of the Localization mechanism which is mostly
  ported from Ramaze.

* Sean Russell

  For REXML, it's one of the engines that drive nagoro.

* Sean Chittenden and Wai-Sun Chia

  For libxml-ruby, it's one of the engines that drive nagoro.
