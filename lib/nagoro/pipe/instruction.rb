module Nagoro
  module Pipe
    class Instruction < Base
      def instruction(name, instruction)
        instruction.strip!
        @body <<
          case name
          when 'js', 'javascript'
            %{<script type="text/javascript"> #{instruction} </script>}
          when /^js:src$/
            %{<script type="text/javascript" src="#{instruction}"></script>}
          when 'css'
            %{<style type="text/css"> #{instruction} </style>}
          when /^css:src$/
            %{<style type="text/css" src="#{instruction}"></style>}
          else
            "<?#{name} #{instruction} ?>"
          end
      end
    end
  end
end
