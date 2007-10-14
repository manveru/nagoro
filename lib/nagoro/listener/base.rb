module Nagoro
  module Listener
    class Base
      include REXML::StreamListener

      attr_accessor :body, :stack

      def initialize(options = {})
        @body = []
        @stack = []
      end

      def tag_start(tag, hash)
        @body << "<#{tag}#{hash.to_tag_params}>"
      end

      def tag_end(tag)
        @body << "</#{tag}>"
      end

      def text(string)
        @body << string
      end

      def instruction(name, instruction)
        @body << "<?#{name}#{instruction}?>"
      end

      def comment(comment)
        @body << "<!--#{comment}-->"
      end

      def doctype(name, pub_sys, long_name, uri)
        @body << "<!DOCTYPE #{name} #{pub_sys} #{long_name} #{uri}>"
      end

      def doctype_end
      end

      def cdata(content)
        @body << "<![CDATA[#{content}]]>"
      end

      def xmldecl(version, encoding, standalone)
        params = {}
        params[:encoding] = encoding if encoding
        params[:standalone] = standalone if standalone
        @body << "<?xml #{params.to_tag_params}?>"
      end

      def to_s
        @body.join
      end
      alias to_str to_s
    end
  end
end
