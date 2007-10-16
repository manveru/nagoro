require 'lib/nagoro'
require 'spec'
require 'rexml/xpath'

class Html < Nagoro::FileElement("example/element/Html.nage")
end

describe 'Nagoro::Render' do
  before :all do
    @nagoro = Nagoro::Template[:Element, :Morpher, :Include, :Instruction]
  end

  def render(file)
    template = @nagoro.render_file(file)
    template.result(binding)
  end

  def xpath(string, path)
    doc = REXML::Document.new(string)
    REXML::XPath.match(doc, path)
  end

  it 'should render elements' do
    doc = render("example/hello.nag")
    xpath(doc, "//title").first.text.should == 'Hello, World!'
    xpath(doc, "//h1").first.text.should == 'Hello, World!'
  end
end
