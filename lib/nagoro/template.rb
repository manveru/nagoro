module Nagoro
  DEFAULT_PIPES = [ :Element, :Morph, :Include, :Instruction, :Compile ]

  class << self
    # filename => _file
    # :to_str => _string
    # :read => _string

    def generic_dispatch(obj, file_meth, io_meth)
      if obj.respond_to?(:to_str)
        str = obj.to_str
        if File.file?(str)
          yield(str, file_meth)
        else
          yield(str, io_meth)
        end
      elsif obj.respond_to?(:read)
        yield(str, io_meth)
      else
        raise("Invalid Argument, %p should be filename, String or IO" % obj)
      end
    end

    def compile(obj, options = {})
      generic_dispatch(obj, :compile_file, :compile_io) do |o, meth|
        nagoro = Template.new(options)
        nagoro.send(meth, o)
        nagoro
      end
    end

    def render(obj, options = {})
      compile(obj, options).result
    end
  end

  class Template
    class << self
      def [](*pipes)
        new(:pipes => pipes.flatten)
      end
    end

    attr_accessor :pipes, :compiled, :options

    def initialize(options = {})
      @options = {
        :binding => binding,
        :file => '<nagoro eval>',
        :pipes => DEFAULT_PIPES,
      }.merge(options)

      @pipes = @options[:pipes].map{|pipe|
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
      @options[:file] = filename
      compile_io(file)
    ensure
      file.close unless file.closed?
      self
    end

    def compile_io(io)
      options[:file] ||= '<nagoro eval>'
      @compiled = pipeline(io).to_ruby
      self
    end

    def pipeline(io)
      pipes.inject(io) do |template, pipe|
        pipe.process(template)
        html = pipe.to_html
        pipe.reset
        html
      end
    end

    def result
      binding, file = @options.values_at(:binding, :file)
      raise(RuntimeError, "Compile or filter first") unless @compiled
      raise(ArgumentError, "Binding required for eval") unless binding
      eval(@compiled, binding, file).strip
    end
  end
end
