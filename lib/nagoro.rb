require 'rexml/rexml'
require 'rexml/streamlistener'
require 'rexml/document'

class Hash
  def to_tag_params
    inject('') do |s,v|
      s << %{ #{v[0]}="#{v[1]}"}
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'nagoro/listener/element'
require 'nagoro/listener/morpher'
require 'nagoro/listener/instruction'
require 'nagoro/listener/include'
require 'nagoro/listener/compile'
require 'nagoro/element'
require 'nagoro/render'
