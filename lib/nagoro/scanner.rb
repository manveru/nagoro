require 'strscan'

module Nagoro
  class Scanner < StringScanner
    TEXT = /[^<>]+/m
    DOCTYPE = /<!DOCTYPE([^>]+)>/m

    TAG_START       = /<([^\s>]+)/n
    TAG_END         = /<\/([^>]*)>/
    TAG_OPEN_END    = /\s*>/n
    TAG_CLOSING_END = /\s*\/>/n
    TAG_PARAMETER   = /\s*([^\s]*)=(['"])(.*?)\2/um

    INSTRUCTION_START = /<\?(\S+)/n
    INSTRUCTION_END   = /(.*?)(\?>)/um

    RUBY_INTERP_START = /#\{/
    RUBY_INTERP_END   = /(?=\})/

    def initialize(string, callback)
      @callback = callback
      super(string)
    end

    def stream
      until eos?
        pos = self.pos
        run
        raise("Scanner didn't move: %p" % self) if pos == self.pos
      end
    end

    def run
      if    scan(DOCTYPE          ); doctype(self[1])
      elsif scan(INSTRUCTION_START); instruction(self[1])
      elsif scan(TAG_END          ); tag_end(self[1])
      elsif scan(RUBY_INTERP_START); ruby_interp(self.matched)
      elsif scan(TAG_START        ); tag_start(self[1])
      elsif scan(TEXT             ); text(self.matched)
      end
    end

    def instruction(name)
      scan(INSTRUCTION_END)
      @callback.instruction(name, self[1])
    end

    def ruby_interp(string)
      string << scan_until(RUBY_INTERP_END)
      @callback.text(string)
    end

    def tag_start(name)
      args = {}

      while scan(TAG_PARAMETER)
        args[self[1]] = self[3]
      end

      @callback.tag_start(name, args)
      return @callback.tag_end(name) if scan(TAG_CLOSING_END)
      scan(TAG_OPEN_END)
    end

    def tag_end(name)
      @callback.tag_end(name)
    end

    def text(string)
      @callback.text(string)
    end

    def doctype(string)
      @callback.doctype(string)
    end
  end
end
