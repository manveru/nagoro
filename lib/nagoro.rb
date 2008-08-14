$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'nagoro/version'
require 'nagoro/template'

module Nagoro
  def self.compile(io, options = {})
    Template.new.compile(io, options)
  end

  def self.render(obj, options = {})
    compile(obj, options).result
  end
end
