class Hash
  def to_tag_params
    inject('') do |s,v|
      s << %{ #{v[0]}="#{v[1]}"}
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.uniq!

require 'nagoro/version'
require 'nagoro/pipe/base'
require 'nagoro/pipe/element'
require 'nagoro/pipe/morph'
require 'nagoro/pipe/instruction'
require 'nagoro/pipe/include'
require 'nagoro/element'
require 'nagoro/template'

module Nagoro
  class << self
    def load_libxml
      require "nagoro/wrap/libxml"
      :libxml
    end

    def load_rexml
      puts "Please install libxml-ruby for better performance, using REXML now."
      require 'nagoro/wrap/rexml'
      :rexml
    end
  end
end

engine =
  if ENV['NAGORO_REXML']
    Nagoro::load_rexml
  else
    begin
      Nagoro::load_libxml
    rescue LoadError => ex
      puts ex
      Nagoro::load_rexml
    end
  end

Nagoro::ENGINE = engine
