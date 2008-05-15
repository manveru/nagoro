require 'lib/nagoro'
require 'spec/core_extensions'

require 'stringio'
require 'rexml/document'
require 'rexml/xpath'
require 'pp'

require 'rubygems'
require 'bacon'

Bacon.summary_on_exit
Bacon.extend(Bacon::TestUnitOutput)

shared 'xpath' do
  def xpath(string, path)
    doc = REXML::Document.new(string)
    REXML::XPath.match(doc, path)
  end
end
