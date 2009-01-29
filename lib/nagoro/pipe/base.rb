module Nagoro
  module Pipe
    class Base
      EMPTY_TAG = %w[ area base basefont br col frame hr
                      img input isindex link meta param ]

      def initialize(io)
        @body, @stack = [], []
        @scanner = Scanner.new(io, self)
      end

      def result
        @scanner.stream
        @body.join
      end

      def tag_start(tag, args)
        case tag
        when *EMPTY_TAG
          append "#{tag_with(tag, args)} />"
        else
          append "#{tag_with(tag, args)}>"
        end
      end

      def tag_end(tag)
        case tag
        when *EMPTY_TAG
        else
          append "</#{tag}>"
        end
      end

      def text(string)
        append(string)
      end

      def append(string)
        @body << string
      end

      def instruction(name, instruction)
        instruction.strip!
        append "<?#{name} #{instruction} ?>"
      end

      def tag_with(tag, hash)
        "<#{tag}#{hash.map{|k,v| %( #{k}="#{v}") }.join}"
      end

      def doctype(string)
        string.strip!
        append "<!DOCTYPE #{string}>"
      end
    end
  end
end
