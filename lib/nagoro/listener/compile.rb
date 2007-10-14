module Nagoro
  module Listener
    class Compile < Base
      def initialize(options = {})
        super
        @compiled = nil

        @delim = "T" << rand(8 << 100).to_s
        @start_heredoc = "\n<<#@delim\n"
        @end_heredoc = "\n#@delim\n"
        @holder = "_out_"
        @bufadd = "#@holder << "
      end

      def instruction(name, instruction)
        @body <<
          case name
          when /^(r|rb|ruby)$/
            "#@end_heredoc #{instruction}; #@bufadd #@start_heredoc" 
          else
            "<?#{name}#{instruction}?>"
          end
      end

      def to_s
"#@holder = ''
#@bufadd #@start_heredoc #@body #@end_heredoc
#@holder"
      end
    end
  end
end
