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
  ENGINES = [:stringscanner, :libxml, :rexml]
  ENGINE = nil

  def self.engine=(name)
    require "nagoro/wrap/#{name}"
    remove_const('ENGINE') if defined?(Nagoro::ENGINE)
    const_set('ENGINE', name.to_sym)
  end

  self.engine = ENV['NAGORO_ENGINE'] || 'stringscanner'
end
