module Nagoro
  module Pipe
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
        File.read(file).strip
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

