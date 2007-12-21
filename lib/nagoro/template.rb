module Nagoro
  DEFAULT_PIPES = [ :Element, :Morph, :Include, :Instruction, :Compile ]

  class << self
    # options
    #   :file
    #   :pipes
    #   :binding
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

  class TemplateEmptyBindingSpace
    # provide 'empty' binding as public method
    def self.binding
      super
    end
  end

  class Template
    def self.[](*pipes)
      new(:pipes => pipes)
    end

    attr_accessor :pipes, :compiled, :options

    def initialize(options = {})
      @options = {
        :binding => TemplateEmptyBindingSpace.binding,
        :pipes => DEFAULT_PIPES,
      }.merge(options)

      @pipes = [@options[:pipes]].flatten.map{|pipe|
        if pipe.respond_to?(:process)
          pipe
        else
          Pipe.const_get(pipe).new
        end
      }
    end

    def compile_file(filename)
      raise "File does not exist" unless File.file?(filename)
      file = File.new(filename)
      compile_io(file, filename)
    ensure
      file.close unless file.closed?
      self
    end

    def compile_io(io, filename = '<nagoro eval>')
      options[:file] ||= filename
      string = io.respond_to?(:read) ? io.read : io.to_str
      @compiled = pipeline(string)
      self
    end

    def pipeline(io)
      pipes.inject(io) do |template, pipe|
        pipe.reset
        pipe.process(template)
        pipe.result
      end
    end

    def result(options = {})
      @options.merge!(options)
      binding, file = @options.values_at(:binding, :file)
      raise(RuntimeError, "Compile or filter first") unless @compiled
      raise(ArgumentError, "Binding required for eval") unless binding
      eval(@compiled, binding, file).strip
    end
  end
end
