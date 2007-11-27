module Nagoro
  module Pipe
    class Instruction < Base
      def instruction(name, instruction)
        @body <<
          case name
          when 'js', 'javascript'
            %{<script type="text/javascript">#{instruction}</script>}
          when /^js:(.*)$/
            %{<script type="text/javascript" src="#$1"></script>}
          when 'css'
            %{<style type="text/css">#{instruction}</style>}
          when /^css:(.*)$/
            %{<style type="text/css" src="#$1"></style>}
          when /^(\d+).times$/
            %{<?r #$1.times do ?>#{instruction}<?r end ?>}
          else
            "<?#{name}#{instruction}?>"
          end
      end
    end
  end
end
