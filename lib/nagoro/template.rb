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
      @binding = options.fetch(:binding, BindingProvider.binding)
      @file = options.fetch(:file, DEFAULT_FILE)
      @pipes = options.fetch(:pipes, DEFAULT_PIPES)
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
      eval(@compiled, @binding, @file).strip
    end

    def render(io, options = {})
      compile(io, options).result
    end
  end
end

__END__
require 'logger'

module Nagoro
  DEFAULT_PIPES = [ :Element, :Morph, :Include, :Instruction, :Compile ]
  DEFAULT_FILE = '<nagoro eval>'

  class << self
    # options
    #   :file
    #   :pipes
    #   :binding
    #   :logger
    #
    def render(obj, options = {})
      compile(obj, options).result
    end

    def compile(obj, options = {})
      if obj.respond_to?(:to_str)
        str = obj.to_str
        if File.file?(str)
          compile_file(str, options)
        else
          compile_io(str, options)
        end
      elsif obj.respond_to?(:read)
        compile_io(obj, options)
      else
        raise("Invalid Argument, %p should be filename, String or IO" % obj)
      end
    end

    def compile_io(obj, options = {})
      nagoro = Template.new(options)
      nagoro.compile_io(obj)
      nagoro
    end

    def compile_file(obj, options = {})
      nagoro = Template.new(options)
      nagoro.compile_file(obj)
      nagoro
    end
  end

  class CleanBinding
    # provide 'empty' binding as public method
    def self.binding
      super
    end
  end

  class Template
    def self.[](*pipes)
      new(:pipes => pipes)
    end

    attr_accessor :pipes, :compiled

    # options
    attr_accessor :binding, :pipes, :logger, :file

    def initialize(options = {})
      apply_options(options)
    end

    def compile_file(filename)
      raise "File does not exist" unless File.file?(filename)

      File.open(filename) do |file|
        compile_io(file, filename)
      end

      self
    end

    def compile_io(io, filename = '<nagoro eval>')
      @file = filename
      string = io.respond_to?(:read) ? io.read : io.to_str
      @compiled = pipeline(string)

      self
    end

    def pipeline(io)
      template = io

      pipes.each do |pipe|
        pipe.reset
        pipe.call(template)
        template = pipe.result
      end

      template
    end

    def result(options = {})
      apply_options(options)

      raise(RuntimeError, "Compile or filter first") unless @compiled
      raise(ArgumentError, "Binding required for eval") unless binding
      eval(@compiled, binding, file).strip
    end

    def apply_options(options = {})
      @binding = options[ :binding ] || CleanBinding.binding
      @file    = options[ :file    ] || DEFAULT_FILE
      @logger  = options[ :logger  ] || Logger.new($stderr)
      @pipes   = options[ :pipes   ] || DEFAULT_PIPES

      @pipes = @pipes.to_ary.map{|pipe|
        next(pipe) if pipe.respond_to?(:call)
        Pipe.const_get(pipe).new
      }
    end
  end
end
