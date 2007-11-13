require 'lib/nagoro'
require 'spec'
require 'rexml/xpath'

module NagoroSpecEnvironment
  def render(string)
    @nagoro.render(string).result(binding)
  end

  def render_file(file)
    @nagoro.render_file(file).result(binding)
  end

  def xpath(string, path)
    doc = REXML::Document.new(string)
    REXML::XPath.match(doc, path)
  end

  def pipeline(string)
    @nagoro.pipeline(string)
  end
end

Spec::Runner.configure do |config|
  config.include NagoroSpecEnvironment
end
