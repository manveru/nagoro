require 'lib/nagoro'
require 'spec'
require 'rexml/document'
require 'rexml/xpath'
require 'pp'

# Extensions for Kernel

module Kernel
  # This is similar to +__FILE__+ and +__LINE__+, and returns a String
  # representing the directory of the current file is.
  # Unlike +__FILE__+ the path returned is absolute.
  #
  # This method is convenience for the
  #  File.expand_path(File.dirname(__FILE__))
  # idiom.
  #
  unless defined?__DIR__
    def __DIR__()
      filename = caller[0][/(.*?):/, 1]
      File.expand_path(File.dirname(filename))
    end
  end
end

# Extensions for String

class String

  # A convenient way to do File.join
  #
  # Example:
  #   'a' / 'b'                      # -> 'a/b'
  #   File.dirname(__FILE__) / 'bar' # -> "ramaze/snippets/string/bar"

  def / obj
    File.join(self, obj.to_s)
  end
end


module NagoroSpecEnvironment
  def xpath(string, path)
    doc = REXML::Document.new(string)
    REXML::XPath.match(doc, path)
  end
end

Spec::Runner.configure do |config|
  config.include NagoroSpecEnvironment
end
