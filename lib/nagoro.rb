$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'nagoro/version'
require 'nagoro/template'

module Nagoro
  autoload :Tidy, 'nagoro/tidy'

  def self.compile(io, options = {})
    Template.new.compile(io, options)
  end

  def self.render(obj, options = {})
    compile(obj, options).result
  end

  def self.tidy_render(obj, options = {})
    compile(obj, options).tidy_result
  end

  class Error < StandardError; end
end
