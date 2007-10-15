module Nagoro
  class Render
    attr_accessor :listeners, :binding, :file

    def initialize(*listeners)
      @listeners = listeners.flatten
      @file = '<nagoro eval>'
    end

    def from_file(file)
      @file = file
      filter(File.new(file))
    end

    def from_string(string, file = '<eval>')
      @file = file
      filter(string)
    end

    def filter(object)
      if listeners.empty?
        template = object
      else
        template = listeners.inject(object){|template, listener|
          listener = listener.new
          REXML::Document.parse_stream(template, listener)
          listener.to_s
        }
      end

      compile(template)
    end

    def compile(template)
      template = template.read if template.respond_to?(:read)
      temp = template.gsub('`', '\\\\`')
      temp.gsub!(/<\?r\s+(.*?)\s+\?>/m, "`;\\1; _out_ << %Q`")

      @compiled = "_out_ = []; _out_ << %Q`#{temp}`; _out_.join"
    end

    alias _eval eval unless defined?(_eval)

    def eval(binding = @binding, file = @file)
      raise(RuntimeError, "Compile or filter first") unless @compiled
      raise(ArgumentError, "Binding required for eval") unless binding
      _eval(@compiled, binding, file).strip
    end
  end
end
