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
    render('text').should == 'text'
    render('#{1 + 1}').should == '2'
  end

  it 'should pipeline instructions' do
    pipeline('<?r a = 1 ?>').
      should == '<?r a = 1 ?>'
  end

  it 'should render instruction' do
    render('<?r a = 1 ?>').
      should == ''
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
    render('<?r i = 2 ?>#{i * i}').
      should == '4'
  end

  it 'should render nested <?r ?> correct in combination with #{}' do
    @a = %w[foo bar foobar]
    render('<?r if @a.empty? ?>No Tasks<?r else ?><?r @a.each do |a,b| ?>[#{a}]<?r end ?><?r end ?>').
      should == '[foo][bar][foobar]'
  end
end
