module Nagoro
  module Pipe
    class Compile < Base
      def instruction(name, instruction)
        append(
          case name
          when 'r'
            "`;#{instruction}; _out_ << %Q`"
          when 'ro'
            "`;_out_ << (#{instruction}); _out_ << %Q`"
          else
            "<?#{name} #{instruction}?>"
          end
        )
      end

      def to_html
        @render = @body.join
        self
      end

      def to_ruby
        out = "_out_ = []; _out_ << %Q`#{@render}`; _out_.join"
        @render = nil
        out
      end

      def compile(template)
        template = template.read if template.respond_to?(:read)
        copy = template.gsub('`', '\\\\`')
        compile!(copy)
      end
    end
  end
end
