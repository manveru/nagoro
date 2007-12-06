require 'xml/libxml'

module Nagoro
  module Wrap
    class XMLReader
      CONST_NAMES = {}

      XML::Reader.constants.each do |const|
        name = const.gsub(/TYPE_/, '').downcase
        CONST_NAMES[XML::Reader.const_get(const)] = name
      end

      CONST_KEYS = CONST_NAMES.keys.sort
      CONST_VALUES = CONST_NAMES.values_at(*CONST_KEYS)

      # Enclose whole document with this tag to make parsing fragments with
      # multiple or no document-roots possible.
      ENCLOSE = 'nagoro'

      # Do not enclose a document that matches.
      ENCLOSE_FOR = [
        /\A\s*[^<]/,
        /\A\s*<(?!\?xml)/,
      ]

      def initialize(string, callback = self)
        @callback = callback
        @reader = XML::Reader.new(string)
        @reader.set_error_handler{|*error| @callback.libxml_reader_error(*error) }
      end

      def valid?
        @reader.valid?
      end

      def read
        @reader.read == 0
      end

      def read_all
        until read
          case @reader.node_type
          when XML::Reader::TYPE_ELEMENT
            tag_start
          when XML::Reader::TYPE_END_ELEMENT
            tag_end
          when XML::Reader::TYPE_PROCESSING_INSTRUCTION
            instruction
          when XML::Reader::TYPE_SIGNIFICANT_WHITESPACE
            significant_whitespace
          when XML::Reader::TYPE_TEXT, XML::Reader::MODE_EOF
            text
          when XML::Reader::TYPE_DOCUMENT_TYPE
            document_type
          else
            raise "Unknown @reader.node_type: #{@reader.node_type}"
          end
        end
      end

      def tag_start
        tag = @reader.name
        return if tag == ENCLOSE
        @callback.tag_start(tag, extract_attributes)
        tag_end if @reader.empty_element?
      end

      def text
        string = @reader.read_string
        @callback.text(string)
      end

      def tag_end
        tag = @reader.name
        return if tag == ENCLOSE
        @callback.tag_end(tag)
      end

      def instruction
        @callback.instruction(@reader.name, @reader.value)
      end

      def significant_whitespace
        @callback.text(@reader.value)
      end

      def document_type
        name = @reader.name
      end

      def extract_attributes
        attributes = {}

        if @reader.has_attributes?
          @reader.move_to_first_attribute
          attributes[@reader.name] = @reader.value
          until @reader.move_to_next_attribute == 0
            attributes[@reader.name] = @reader.value
          end
          @reader.move_to_element
        end

        attributes
      end
    end
  end

  module Patch
    module XMLReader
      # Enclose whole document with this tag to make parsing fragments with
      # multiple or no document-roots possible.
      ENCLOSE = Wrap::XMLReader::ENCLOSE

      # Do not enclose a document that matches.
      ENCLOSE_FOR = Wrap::XMLReader::ENCLOSE_FOR

      def process(template)
        @reader = create_parser(template)
        @reader.read_all
      end

      def create_parser(obj)
        string = obj.respond_to?(:read) ? obj.read : obj.to_s
        string = enclose(string)
        reader = Wrap::XMLReader.new(string, self)
        reader
      end

      def loaddtd
      end

      def libxml_reader_error(reader, message, error_const, unknown, unknown_1)
        type = Wrap::XMLReader::CONST_NAMES[error_const]
        message.strip!

        case message
        when /ParsePI: (.*)/
          raise Error::Parse::PI, $1
        when /StartTag: (.*)/
          raise Error::Parse::StartTag, $1
        end

        raise Error::Parse, message
      end

      def enclose(string)
        case string
        when *ENCLOSE_FOR
          "<#{ENCLOSE}>#{string}</#{ENCLOSE}>"
        else
          string
        end
      end

      def valid?
        @reader.valid?
      end
    end
  end

  module Pipe
    class Base
      include Patch::XMLReader
    end
  end
end
