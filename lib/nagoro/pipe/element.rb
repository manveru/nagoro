module Nagoro
  module Pipe
    class Element < Base
      ELEMENTS = {}

      class ElementStruct < Struct.new(:tag, :attrs, :element, :content)
      end

      def tag_start(tag, attrs)
        if element = ELEMENTS[tag]
          @stack << ElementStruct.new(tag, attrs, element, [])
        else
          super
        end
      end

      def tag_end(tag)
        estruct = @stack.reverse.find{|e| e.tag == tag}
        if estruct and estruct.tag == tag
          instance = estruct.element.new(estruct.content.join)
          instance.params = translate_attrs(instance, estruct.attrs)

          @stack.pop

          append instance.render
        else
          super
        end
      end

      def append(string)
        if @stack.empty?
          @body << string
        else
          @stack.last.content << string
        end
      end

      def translate_attrs(instance, attrs)
        hash = {}
        attrs.each do |key, value|
          case value
          when /^@/
            hash[key] = value
          else
            hash[key] = value
          end
        end

        hash
      end
    end
  end
end
