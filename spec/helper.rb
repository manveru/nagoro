require File.expand_path('../../lib/nagoro', __FILE__)
require File.expand_path('../core_extensions', __FILE__)

require 'stringio'
require 'rexml/document'
require 'rexml/xpath'
require 'pp'

require 'rubygems'
require 'bacon'

Bacon.summary_on_exit

shared 'xpath' do
  def xpath(string, path)
    doc = REXML::Document.new(string)
    REXML::XPath.match(doc, path)
  end
end
