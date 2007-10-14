module Nagoro
  class Render
    attr_accessor :listeners, :compiled

    def initialize(*listeners)
      @listeners = listeners.flatten
    end

    def from_file(file)
      filter(File.new(file))
    end

    def from_string(string)
      filter(string)
    end

    def filter(object)
      @compiled =
        listeners.inject(object){|template, listener|
          listener = listener.new
          REXML::Document.parse_stream(template, listener)
          listener.to_s
        }
      self
    end

    alias _eval eval unless defined?(_eval)

    def eval(binding, file = '<eval>')
      _eval(@compiled, binding, file).strip
    end
  end
end
