require 'strscan'

module Nagoro
  class Scanner
    def initialize(string, callback)
      @string, @callback = string, callback
      @scanner = StringScanner.new(string)
    end

    def stream
      until @scanner.eos?
        pos = @scanner.pos
        run
        raise("Scanner didn't move: %p" % @scanner) if pos == @scanner.pos
      end
    end

    def run
      if    @scanner.scan( /<\?([^\s]+)/ ); instruction @scanner[1]
      elsif @scanner.scan( /<\/(.*?)>/   );     tag_end @scanner[1]
      elsif @scanner.scan( /#\{/         ); ruby_interp @scanner.matched
      elsif @scanner.scan( /<([^\s>]+)/  );   tag_start @scanner[1]
      elsif @scanner.scan( /[^<>]+/mu    );        text @scanner.matched
      end
    end

    def instruction(name)
      @scanner.scan(/(.*?)(\?>)/)
      @callback.instruction(name, @scanner[1])
    end

    def ruby_interp(string)
      string << @scanner.scan_until(/(?=\})/)
      @callback.text(string)
    end

    def tag_start(name)
      args = {}

      while @scanner.scan(/\s*([^\s]*)=(['"])(.*?)\2/)
        args[@scanner[1]] = @scanner[3]
      end

      @callback.tag_start(name, args)
      return @callback.tag_end(name) if @scanner.scan(/\s*\/>/)
      @scanner.scan(/\s*>/)
    end

    def tag_end(name)
      @callback.tag_end(name)
    end

    def text(string)
      @callback.text(string)
    end
  end
end
