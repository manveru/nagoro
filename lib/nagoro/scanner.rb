require 'strscan'

module Nagoro
  class Scanner < StringScanner
    TEXT = /[^<>#]+/m
    HASH_TEXT = /#[^\{<]#{TEXT}/m
    HASH_CHAR = /#/
    DOCTYPE = /<!DOCTYPE([^>]+)>/m

    TAG_START       = /<([^\s>]+)/
    TAG_END         = /<\/([^>]*)>/
    TAG_OPEN_END    = /\s*>/
    TAG_CLOSING_END = /\s*\/>/
    TAG_PARAMETER   = /\s*([^\s=]*)=((['"])(.*?)\3)/um

    INSTRUCTION_START = /<\?(\S+)/
    INSTRUCTION_END   = /(.*?)(\?>)/um

    RUBY_INTERP_START = /\s*#\{/m
    RUBY_INTERP_TEXT  = /[^\{\}]+/m
    RUBY_INTERP_NEST  = /\{[^\}]*\}/m
    RUBY_INTERP_END   = /(?=\})/
    RUBY_TAG_INTERP   = /\s*(#\{.*?\})/m

    COMMENT = /<!--.*?-->/m

    def initialize(string, callback)
      @callback = callback
      super(string)
    end

    def stream
      until eos?
        pos = self.pos
        run
        raise(Stuck, "Scanner didn't move: %p" % self) if pos == self.pos
      end
    end

    def run
      if    scan(DOCTYPE          ); doctype(self[1])
      elsif scan(INSTRUCTION_START); instruction(self[1])
      elsif scan(COMMENT          ); text(matched)
      elsif scan(TAG_END          ); tag_end(self[1])
      elsif scan(RUBY_INTERP_START); ruby_interp(matched)
      elsif scan(TAG_START        ); tag_start(self[1])
      elsif scan(TEXT             ); text(matched)
      elsif scan(HASH_CHAR        ); hash_char(matched)
      end
    end

    def instruction(name)
      scan(INSTRUCTION_END)
      @callback.instruction(name, self[1])
    end

    def ruby_interp(string)
      done = false

      until done
        if    scan(RUBY_INTERP_TEXT)
          string << matched
        elsif scan(RUBY_INTERP_NEST)
          string << matched
        elsif scan(RUBY_INTERP_END)
          done = true
        end
      end

      @callback.text(string)
    end

    def tag_start(name)
      original_attrs = {}
      value_attrs = {}

      done = false
      while not done
        if scan(RUBY_TAG_INTERP)
          original_attrs[self[1]] = nil
          value_attrs[self[1]] = nil
        elsif scan(TAG_PARAMETER)
          original_attrs[self[1]] = self[2] # <a href="foo"> gives 'href'=>'"foo"'
          value_attrs[   self[1]] = self[4] # <a href="foo"> gives 'href'=>'foo'
        elsif scan(TAG_CLOSING_END)
          @callback.tag(name, original_attrs, value_attrs)
          done = true
        elsif scan(TAG_OPEN_END)
          @callback.tag_start(name, original_attrs, value_attrs)
          done = true
        end
      end
    end

    def tag_end(name)
      @callback.tag_end(name)
    end

    def text(string)
      if scan(HASH_TEXT)
        string << matched
      end
      @callback.text(string)
    end

    def hash_char(string)
      @callback.text(string)
    end

    def doctype(string)
      @callback.doctype(string)
    end

    class Stuck < Error; end
  end
end
