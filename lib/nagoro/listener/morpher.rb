require 'nagoro/listener/base'

module Nagoro
  module Listener
    class Morpher < Base
      MORPHS = {
      'if'     => {
        :start => '<?r %morph %expression ?>',
        :body => '%content',
        :end => '<?r end ?>',
      },
      'unless' => {
        :start => '<?r %morph %expression ?>',
        :body => '%content',
        :end => '<?r end ?>',
      },
      'for' => {
        :start => '<?r %morph %expression ?>',
        :body => '%content',
        :end => '<?r end ?>',
      },
      'each' => {
        :start => '<?r %expression.%morph do |_e| ?>',
        :body => '%content',
        :end => '<?r end ?>',
      },
      'times' => {
        :start => '<?r %expression.%morph do |_t| ?>',
        :body => '%content',
        :end => '<?r end ?>',
      },
      }

      def tag_start(tag, hash)
        morphs = hash.keys & MORPHS.keys
        if morphs.empty?
          super(tag, hash)
        elsif morphs.size > 1
          raise "Cannot transform multiple morphs per tag"
        else
          morph = morphs.first
          value = hash[morph]
          expression = MORPHS[morph]
          e_start = expression[:start]
          e_body = expression[:body]
          hash.delete morph

          @body << e_start.
            gsub("%morph", morph).
            gsub("%expression", value)
          @stack << [tag, morph]
          super(tag, hash)
        end
      end

      def tag_end(tag)
        super(tag)

        prev, morph = @stack.last
        if prev == tag
          e_end = MORPHS[morph][:end]
          @body << e_end
          @stack.pop
        end
      end

      def text(string)
        @body << string
      end
    end
  end
end
