require 'strscan'

module Nagoro
  module Patch
    class Streamer
      attr_accessor :string, :callback, :scanner

      def initialize(string, callback)
        @string = string
        @callback = callback
        @scanner = ::StringScanner.new(string)
      end

      def stream
        until @scanner.eos?
          pos = @scanner.pos
          run
          raise("Scanner didn't move: %p" % scanner) if pos == @scanner.pos
        end
      end

      def run
        if scan(/<\?([^\s]+)/)
          instruction scanner[1]
        elsif scan(/<\/(.*?)>/)
          @callback.tag_end scanner[1]
        elsif scan(/#\{/)
          ruby_interp
        elsif scan(/<([^\s>]+)/)
          tag_start(scanner[1])
        elsif scan(/[^<>]+/mu)
          @callback.text(matched)
        end
      end

      def ruby_interp
        text = matched
        text << scan_until(/(?=\})/)
        @callback.text text
      end

      def instruction(name)
        scan(/(.*?)(\?>)/)
        @callback.instruction(name, scanner[1])
      end

      def tag_start(name)
        args = {}

        while scan(/\s*([^\s]*)=(['"])(.*?)\2/)
          args[scanner[1]] = scanner[3]
        end

        @callback.tag_start(name, args)

        if scan(/\s*\/>/)
          @callback.tag_end(name)
        elsif scan(/\s*>/)
        end
      end

      def scan(expression)
        @scanner.scan(expression)
      end

      def scan_until(expression)
        @scanner.scan_until(expression)
      end

      def matched
        @scanner.matched
      end
    end

    module StringScanner
      def process(template, ezamar_compatible = true)
        streamer = Streamer.new(template, self)
        streamer.stream
      end
    end
  end

  module Pipe
    class Base
      include Patch::StringScanner
    end
  end
end
