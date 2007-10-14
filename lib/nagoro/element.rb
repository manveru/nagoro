module Nagoro
  class Element
    attr_accessor :content, :params

    def initialize(content)
      @content = content
    end

    def render
      @content
    end

    def params=(params = {})
      params.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def self.inherited(klass)
      Nagoro::Listener::Element::ELEMENTS[klass.to_s] = klass
    end
  end

  # FileElement puts created elements into this module
  module GeneratedElement
  end

  def self.FileElement(file)
    element = Class.new(Element){
      define_method(:element_file){
        file
      }

      def render
        main = File.read(element_file)
        @delim = "T" << rand(8 << 100).to_s
        eval(%{<<#@delim\n#{main}\n#@delim})
      end
    }
    name = File.basename(file, File.extname(file))
    GeneratedElement::const_set(name, element)
    Listener::Element::ELEMENTS.delete_if{|k,v| v == element}
    Listener::Element::ELEMENTS[name] = element
    element
  end
end
