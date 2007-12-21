__END__
require 'xml/libxml'

module Nagoro
  module Wrap
    class XMLReader
      CONST_NAMES = {}

      XML::Reader.constants.each do |const|
        name = const.gsub(/TYPE_/, '').downcase
        CONST_NAMES[XML::Reader.const_get(const)] = name
      end

      def initialize(string)
        @reader = XML::Reader.new(string)
        @reader.set_error_handler{|*error| handle_error(*error) }
      end

      def read
        @reader.read
      end

      def read_all
        const_keys = CONST_NAMES.keys.sort
        const_values = CONST_NAMES.values_at(*const_keys)

        until @reader.read == 0
          case @reader.node_type
          when *const_keys
            send const_values[@reader.node_type]
          else
            raise "bleep #{@reader.node_type}"
          end
        end
      end

      def method_missing(meth, *args, &block)
        p meth => args


        p :name => @reader.name,
          :node_type => @reader.node_type,
          :value =>  @reader.value,
          :attributes => attributes
      end

      # Implementation

      def loaddtd
      end

      def element
        attributes = {}
        if @reader.has_attributes?
          @reader.move_to_first_attribute
          attributes[@reader.name] = @reader.value
          until @reader.move_to_next_attribute == 0
            attributes[@reader.name] = @reader.value
          end
          @reader.move_to_element
        end
      end

      def handle_error(reader, message, error_const, unknown, unknown_1)
        type = CONST_NAMES[error_const]
        raise "#{type}: #{message}"
      end
    end
  end
end

wrap = Nagoro::Wrap::XMLReader.new('<html><h1 class="foo" id="bar">foobar</h1></html>')
wrap.read_all
