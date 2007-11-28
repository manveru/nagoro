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
$LOAD_PATH.uniq!

require 'nagoro/version'
require 'nagoro/pipe/base'
require 'nagoro/pipe/element'
require 'nagoro/pipe/morpher'
require 'nagoro/pipe/instruction'
require 'nagoro/pipe/include'
require 'nagoro/element'
require 'nagoro/template'
