require 'spec/helper'

class Html < Nagoro::FileElement("example/element/Html.nage")
end

describe 'Nagoro::Render' do
  before :all do
    @nagoro = Nagoro::Template[:Element, :Morpher, :Include, :Instruction]
  end

  it 'should render elements' do
    doc = render_file("example/hello.nag")
    xpath(doc, "//title").first.text.should == 'Hello, World!'
    xpath(doc, "//h1").first.text.should == 'Hello, World!'
  end

  it 'should render normal stuff' do
    render('<?r i = 2 ?>#{i * i}').
      should == '4'
  end
end
