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
          filename = attrs['href'] || attrs.fetch('src')
          append contents(filename)
        else
          super
        end
      end

      def contents(file)
        open(file){|o| o.read.strip }
      rescue Errno::ENOENT, Errno::EISDIR => ex
        warn ex.message
        "<!-- #{ex} -->"
      end

      def tag_end(tag)
        super unless tag == 'include'
      end
    end
  end
end
