module Nagoro
  module Pipe

    # Instruction handles <??> instructions.
    #
    # It is based on a simple interpolation with String#% and one argument, the
    # content of the instruction.
    #
    # If you want to add new instruction-formats, just add it to the
    # Nagoro::Pipe::Instruction::INSTRUCTIONS Hash or use
    # Nagoro::Pipe::Instruction::[] for convinience.
    #
    # The name of the instruction is matched with ===, so you can use regular
    # expressions as keys as well.
    #
    # Syntax and results of available instructions:
    #   <?js alert('Hello, World!'); ?>
    #   # <script type="text/javascript"> alert('Hello, World!'); </script>
    #
    #   <?js:src /js/jquery.js ?>
    #   # <script type="text/javascript" src="/js/jquery.js"></script>
    #
    #   <?css body{ color: #f00; } ?>
    #   # <style type="text/css"> body{ color: #f00; } </style>
    #
    #   <?css:src /css/coderay.css ?>
    #   # <style type="text/css" src="/css/coderay.css"></style>
    #
    # How to add new instructions:
    #   Nagoro::Pipe::Instruction['pre'] = '<pre>%s</pre>'
    #   Nagoro::Pipe::Instruction[/strip/] = '#{%(%s).strip}'

    class Instruction < Base
      INSTRUCTIONS = {
        'js'      => '<script type="text/javascript"> %s </script>',
        'js:src'  => '<script type="text/javascript" src="%s"></script>',
        'css'     => '<style type="text/css"> %s </style>',
        'css:src' => '<style type="text/css" src="%s"></style>',
      }

      DEFAULT = "<?%s %s ?>"

      def instruction(name, instruction)
        instruction.to_s.strip!

        if custom = INSTRUCTIONS[name]
          @body << custom % instruction
        else
          @body << DEFAULT % [name, instruction]
        end
      end

      class << self
        def []=(key, value)
          INSTRUCTIONS[key] = value
        end

        def [](key)
          INSTRUCTIONS[key]
        end
      end
    end
  end
end
