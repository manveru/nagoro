module Nagoro
  module Pipe

    # Include is used to include the contents of another file.
    # The file will not be changed or interpreted in any way by this pipe.
    #
    # If the tag contains anything the contents will be put after the included
    # contents.
    #
    # Syntax:
    #   <include href="some_file.xhtml" />
    #   <include src="some_file.xhtml" />

    class Include < Base
      def tag_start(tag, attrs)
        if tag == 'include'
          filename = attrs.fetch('href', attrs.fetch('src'))
          @body << contents(filename)
        else
          @body << "<#{tag}#{attrs.to_tag_params}>"
        end
      end

      def contents(file)
        open(file){|o| o.read.strip }
      rescue Errno::ENOENT, Errno::EISDIR => ex
        "<!-- #{ex} -->"
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
