class Hash
  def to_tag_params
    map{|k,v| %( #{k}="#{v}") }.join
  end
end

class String
  # 1.9 compat
  unless method_defined?(:ord)
    def ord
      self[0]
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.uniq!

require 'nagoro/version'
require 'nagoro/error'
require 'nagoro/element'
require 'nagoro/template'
require 'nagoro/pipe/base'
require 'nagoro/pipe/element'
require 'nagoro/pipe/morph'
require 'nagoro/pipe/instruction'
require 'nagoro/pipe/include'
require 'nagoro/pipe/compile'

module Nagoro
  class << self
    def load_libxml
      require "nagoro/wrap/libxml"
      :libxml
    end

    def load_rexml
      # puts "Please install libxml-ruby for better performance, using REXML now."
      require 'nagoro/wrap/rexml'
      :rexml
    end

    def load_stringscanner
      require 'nagoro/wrap/stringscanner'
      :stringscanner
    end
  end
end

engine = ENV['NAGORO_ENGINE'] || 'stringscanner'
engine = engine.downcase

engine =
  begin
    Nagoro.send("load_#{engine}")
  rescue LoadError => ex
    puts ex
    Nagoro::load_rexml
  end

Nagoro::ENGINE = engine
