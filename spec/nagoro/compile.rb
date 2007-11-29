require 'spec/helper'

unless defined?(Html)
  class Html < Nagoro::FileElement("example/element/Html.nage")
  end
end

describe 'Nagoro::Render' do
  before :all do
    @nagoro = Nagoro::Template[:Element, :Morpher, :Include, :Instruction]
  end

  it 'should pipeline' do
    pipeline('<p></p>').should == '<p></p>'
    pipeline('<p>text</p>').should == '<p>text</p>'
    pipeline('<p>#{1 + 1}</p>').should == '<p>#{1 + 1}</p>'
  end

  it 'should render' do
    render('<p></p>').should == '<p></p>'
    render('<p>text</p>').should == '<p>text</p>'
    render('<p>#{1 + 1}</p>').should == '<p>2</p>'
  end

  it 'should pipeline instructions' do
    pipeline('<p><?r a = 1 ?></p>').
      should == '<p><?r a = 1 ?></p>'
  end

  it 'should render instruction' do
    render('<p><?r a = 1 ?></p>').
      should == '<p></p>'
  end

  it 'should render elements' do
    doc = render_file("example/hello.nag")
    xpath(doc, "//title").first.text.should == 'Hello, World!'
    xpath(doc, "//h1").first.text.should == 'Hello, World!'
  end

  it 'should pipeline' do
    pipeline('<p if="1"></p>').
      should == '<?r if 1 ?><p></p><?r end ?>'
  end

  it 'should render normal stuff' do
    render('<p><?r i = 2 ?>#{i * i}</p>').
      should == '<p>4</p>'
  end

  it 'should render nested <?r ?> correct in combination with #{}' do
    @a = %w[foo bar foobar]
    render('<p><?r if @a.empty? ?>No Tasks<?r else ?><?r @a.each do |a,b| ?>[#{a}]<?r end ?><?r end ?></p>').
      should == '<p>[foo][bar][foobar]</p>'
  end
end
