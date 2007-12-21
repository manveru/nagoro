module Nagoro
  module Pipe

    # Base is the superclass of most pipes, doing the grudge-work of
    # implementing the common interface for REXML and libxml for them as well
    # as providing all necessary defaults.
    #
    # Be aware that, depending on whether you use REXML or libxml, the specific
    # interface for them is implemented in the respective modules in
    # Nagoro::Patch

    class Base
      attr_accessor :body, :stack

      EMPTY_ELEMENT = %w[ area base basefont br col frame hr
                          img input isindex link meta param ]

      TEXT_IGNORE = [ (0..8), 11, 12, (14..31), (128..255) ]
      TEXT_PASS = [ 9, 10, 13, (32..126) ]

      def initialize(options = {})
        @body = []
        @stack = []
      end

      def tag_start(tag, hash)
        case tag
        when *EMPTY_ELEMENT
          append "<#{tag}#{hash.to_tag_params} />"
        else
          append "<#{tag}#{hash.to_tag_params}>"
        end
      end

      def tag_end(tag)
        case tag
        when *EMPTY_ELEMENT
        else
          append "</#{tag}>"
        end
      end

      def text(string)
        string.gsub!(/./u) do |match|
          case match.ord
          when *TEXT_IGNORE
            # ignore
          when *TEXT_PASS
            match
          else
            "&##{match.ord};" # check
          end
        end
        append string
      end

      def instruction(name, instruction)
        instruction.strip!
        append "<?#{name} #{instruction} ?>"
      end

      def comment(comment)
        append "<!--#{comment}-->"
      end

      def doctype(name, pub_sys, long_name, uri)
        append "<!DOCTYPE #{name} #{pub_sys} #{long_name} #{uri}>"
      end

      def doctype_end
      end

      def cdata(content)
        append "<![CDATA[#{content}]]>"
      end

      def xmldecl(version, encoding, standalone)
        params = {}
        params[:encoding] = encoding if encoding
        params[:standalone] = standalone if standalone
        append "<?xml #{params.to_tag_params}?>"
      end

      def append(string)
        @body << string
      end

      def result
        @body.join
      end

      def preprocess
        if @template.include?('#{')
          @template.gsub!(/#\{((?![^\\]\})*|[^}]*)*\}/, '<?ro \1 ?>')
        end
      end

      def reset
        @body.clear
        @stack.clear
        self
      end
    end
  end
end
