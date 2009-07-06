module Nagoro
  module Pipe
    class Base
      def initialize(io)
        @body, @stack = [], []
        @scanner = Scanner.new(io, self)
      end

      def result
        @scanner.stream
        @body.join
      end

      def tag(tag, original_attrs, value_attrs)
        append "#{tag_with(tag, original_attrs)} />"
      end

      def tag_start(tag, original_attrs, value_attrs)
        append "#{tag_with(tag, original_attrs)}>"
      end

      def tag_end(tag)
        append "</#{tag}>"
      end

      def text(string)
        append(string)
      end

      def append(string)
        @body << string
      end

      def instruction(name, instruction)
        append "<?#{name} #{instruction.to_s.strip} ?>"
      end

      def tag_with(tag, hash)
        "<#{tag}#{hash.map{|k,v| %( #{k}=#{v}) }.join}"
      end

      def doctype(string)
        string.strip!
        append "<!DOCTYPE #{string}>"
      end
    end
  end
end
