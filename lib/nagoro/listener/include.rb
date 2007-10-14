module Nagoro
  module Listener
    class Include < Base
      def tag_start(tag, attrs)
        if tag == 'include'
          filename = attrs.fetch('href', attrs.fetch('src'))
          @body << File.read(filename)
        else
          @body << "<#{tag}#{attrs.to_tag_params}>"
        end
      end

      def tag_end(tag)
        if tag == 'include'
        else
          @body << "</#{tag}>"
        end
      end
    end
  end
end

