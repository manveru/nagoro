module Nagoro
  module Pipe
    class Compile < Base
      def instruction(name, instruction)
        case name
        when 'r'
          append("`;#{instruction}; _out_ << %Q`")
        when 'ro'
          append("`;_out_ << (#{instruction}); _out_ << %Q`")
        else
          append("<?#{name} #{instruction}?>")
        end
      end

      def result
        p @body
        "_out_ = []; _out_ << %Q`#{@body.join}`; _out_.join"
      end

      def compile(template)
        template = template.read if template.respond_to?(:read)
        copy = template.gsub('`', '\\\\`')
        compile!(copy)
      end
    end
  end
end
