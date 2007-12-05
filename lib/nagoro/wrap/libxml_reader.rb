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
      NO_ENCLOSE = [
        /\A\s*<[^?]/,
      ]

      def initialize(string, callback = self)
        @callback = callback
        @reader = XML::Reader.new(string)
        @reader.set_error_handler{|*error| @callback.libxml_reader_error(*error) }
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
          when XML::Reader::MODE_EOF
          when XML::Reader::TYPE_PROCESSING_INSTRUCTION
            instruction
          when XML::Reader::TYPE_SIGNIFICANT_WHITESPACE
            significant_whitespace
          when XML::Reader::TYPE_TEXT
            p :text
            text
          when *CONST_KEYS
            meth = CONST_VALUES[@reader.node_type]
            p :meth => meth
            @callback.send(meth)
          else
            raise "Unknown @reader.node_type: #{@reader.node_type}"
          end
        end
      end

      def tag_start
        tag = @reader.name

        return if tag == ENCLOSE
        attributes = {}
        if @reader.has_attributes?
          @reader.move_to_first_attribute
          attributes[@reader.name] = @reader.value
          until @reader.move_to_next_attribute == 0
            attributes[@reader.name] = @reader.value
          end
          @reader.move_to_element
        end

        @callback.tag_start(tag, attributes)
      end

      def text
        string = @reader.read_string
        p :string => string
        @callback.text(string)
      end

      def tag_end
        tag = @reader.name
        return if tag == ENCLOSE
        @callback.tag_end(tag)
      end

      def instruction
        p :instruction => [@reader.name, @reader.value]
        @callback.instruction(@reader.name, @reader.value)
      end

      def significant_whitespace
        @callback.text(@reader.value)
      end
    end
  end

  module Patch
    module XMLReader
      # Enclose whole document with this tag to make parsing fragments with
      # multiple or no document-roots possible.
      ENCLOSE = Wrap::XMLReader::ENCLOSE

      # Do not enclose a document that matches.
      NO_ENCLOSE = Wrap::XMLReader::NO_ENCLOSE

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
        raise "#{type}: #{message}"
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
      include Patch::XMLReader
    end
  end
end
