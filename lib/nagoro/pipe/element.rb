module Nagoro
  def self.element(name, obj = nil, &block)
    Pipe::Element::ELEMENTS[name] = obj || block
  end

  def self.file_element(name, filename)
    Pipe::Element::ELEMENTS[name] = FileElement(filename)
  end

  module Pipe
    class Element < Base
      ELEMENTS = {}

      class ElementStruct < Struct.new(:tag, :attrs, :element, :content)
      end

      def tag_start(tag, original_attrs, value_attrs)
        if element = ELEMENTS[tag]
          @stack << ElementStruct.new(tag, value_attrs, element, [])
        elsif tag =~ /^[A-Z]/
          warn "Element: '<#{tag}>' not found."
          super
        else
          super
        end
      end

      def tag_end(tag)
        estruct = @stack.reverse.find{|e| e.tag == tag}
        if estruct and estruct.tag == tag
          attrs, element, content = estruct.values_at(1..3)

          @stack.pop

          if element.respond_to?(:call)
            append element.call(content.join, attrs)
          else
            instance = element.new(content.join)
            instance.params = translate_attrs(instance, estruct.attrs)
            append instance.render
          end
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
