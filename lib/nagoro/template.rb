require 'nagoro/scanner'
require 'nagoro/binding'
require 'nagoro/element'

require 'nagoro/pipe/base'
require 'nagoro/pipe/compile'
require 'nagoro/pipe/element'
require 'nagoro/pipe/include'
require 'nagoro/pipe/instruction'
# require 'nagoro/pipe/localization'
require 'nagoro/pipe/morph'

module Nagoro
  DEFAULT_PIPES = [ Pipe::Element, Pipe::Morph, Pipe::Include,
                    Pipe::Instruction, Pipe::Compile ]
  DEFAULT_FILE = '<nagoro eval>'

  class Template
    def self.[](*pipes)
      new(:pipes => pipes.flatten)
    end

    attr_accessor :binding, :file, :pipes, :compiled

    def initialize(options = {})
      parse_option(options)
      @compiled = false
    end

    def parse_option(options = {})
      @binding   = options.fetch(:binding, BindingProvider.binding)
      @file      = options.fetch(:file, DEFAULT_FILE)
      @pipes     = options.fetch(:pipes, DEFAULT_PIPES)
      @variables = options.fetch(:variables, nil)
    end

    def compile(io, options = {})
      parse_option(options) unless options.empty?

      case io
      when String
        io = File.read(io) if File.file?(io)
        @compiled = pipeline(io)
      when StringIO, IO
        @compiled = pipeline(io.read)
      else
        raise("Cannot compile %p" % io)
      end

      return self
    end

    # use inject?
    def pipeline(io)
      @pipes.each do |pipe|
        if pipe.respond_to?(:new)
          io = pipe.new(io).result
        else
          io = Pipe.const_get(pipe).new(io).result
        end
      end
      return io
    end

    def result(options = {})
      parse_option(options) unless options.empty?

      if vars = @variables
        obj = @binding.eval('self')
        obj.instance_variable_set('@_nagoro_ivs', vars)
        @binding.eval(%q(
          @_nagoro_ivs.each{|key, value| instance_variable_set("@#{key}", value) }
        ))
      end

      eval(@compiled, @binding, @file).strip
    end

    def render(io, options = {})
      compile(io, options).result
    end
  end
end
