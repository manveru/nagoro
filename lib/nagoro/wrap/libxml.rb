require 'xml/libxml'

module Nagoro
  module Patch
    module XMLSaxParser

      # Enclose whole document with this tag to make parsing fragments with
      # multiple or no document-roots possible.
      ENCLOSE = 'nagoro'

      # Do not enclose a document that matches.
      NO_ENCLOSE = [
        /\A\s*<\?xml/,
      ]

      # list of methods that SAX::Parser might call.
      # key is method on Patch::XMLSaxParser, value is method on Base

      REXML_MAPPING = {
        :on_cdata_block            => :cdata,
        # :on_characters             => :text,
        :on_comment                => :comment,
        # :on_end_document           => nil,
        :on_end_element            => :tag_end,
        # :on_external_subset        => nil,
        # :on_has_external_subset    => nil,
        # :on_has_internal_subset    => nil,
        # :on_internal_subset        => nil,
        # :on_is_standalone          => nil,
        # :on_method                 => nil,
        # :on_parser_error           => nil,
        # :on_parser_fatal_error     => nil,
        # :on_parser_warning         => nil,
        :on_processing_instruction => :instruction,
        # :on_reference              => nil,
        # :on_start_document         => nil,
        :on_start_element          => :tag_start,
      }

      def method_missing(meth, *args, &block)
        if mapping = REXML_MAPPING[meth]
          # p meth => args
          send(mapping, *args, &block)
        else
          super
        end
      end

      def on_start_document
      end

      def on_end_document
      end

      def on_start_element(tag, hash)
        tag_start(tag, hash) unless tag == ENCLOSE
      end

      def on_end_element(tag)
        tag_end(tag) unless tag == ENCLOSE
      end

      def on_processing_instruction(name, instruction)
        instruction(name, instruction)
      end

      def on_characters(string)
        string =
          case string
          when '<'
            '&lt;'
          when '>'
            '&gt;'
          else
            string
          end

        text(string)
      end

      def on_internal_subset(name, long_name, uri)
        append "<!DOCTYPE #{name} #{long_name} #{uri}>"
      end

      def on_external_subset(name, long_name, uri)
        append "<!DOCTYPE #{name} #{long_name} #{uri}>"
      end

      def on_parser_error(error)
        error.strip!
        case error
        when /^ParsePI: (.*)/
          raise ParsePI, $1
        else
          raise ParseError, error.strip
        end
      end

      def on_parser_fatal_error(error)
        raise ParserFatalError, error.strip
      end

      def on_parser_warning(warning)
        raise ParserWarning, warning.strip
      end

      def process(template)
        parser = create_parser(template)
        parser.callbacks = self
        parser.parse
      end

      def create_parser(obj)
        parser = XML::SaxParser.new
        string = obj.respond_to?(:read) ? obj.read : obj.to_s
        parser.string = enclose(string)
        parser
      end

      def enclose(string)
        case string
        when *NO_ENCLOSE
          string
        else
          "<#{ENCLOSE}>#{string}</#{ENCLOSE}>"
        end
      end
    end
  end

  module Pipe
    class Base
      include Patch::XMLSaxParser
    end
  end
end
