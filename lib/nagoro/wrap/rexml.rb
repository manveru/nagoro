require 'rexml/rexml'
require 'rexml/streamlistener'
require 'rexml/document'

REXML::Parsers::BaseParser::DEFAULT_ENTITIES.clear

module Nagoro
  module Patch
    module REXMLStreamListener
      def process(template)
        REXML::Document.parse_stream(template, self)
      end
    end
  end

  module Pipe
    class Base
      include Patch::REXMLStreamListener
    end
  end
end
