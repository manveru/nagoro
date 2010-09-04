require File.expand_path('../../../helper', __FILE__)

describe "Nagoro::Pipe::Element" do
  behaves_like 'xpath'

  def compile(obj)
    Nagoro::Template[Nagoro::Pipe::Element].compile(obj).compiled
  end

  Nagoro.element('Page') do |content, attrs|
    "(Page: #{content.dump})"
  end

  Nagoro.element('SideBar') do |content, attrs|
    "(SideBar: #{content.dump})"
  end

  Nagoro.file_element('Html', 'example/element/Html.nage')

  it 'should compile single element' do
    compile('<Page />').
      should == '(Page: "")'
  end

  it 'should compile two elements' do
    compile('<Page /><Page />').
      should == '(Page: "")(Page: "")'
  end

  it 'should compile nested elements' do
    compile('<Page><Page /></Page>').
      should == '(Page: "(Page: \\"\\")")'
  end

  it 'should compile different nested elements' do
    compile('<Page><SideBar /></Page>').
      should == '(Page: "(SideBar: \\"\\")")'
  end

  it 'should compile nested instructions in the middle of a text' do
    compile('<Page> x #{test :x => 1}</Page>').
      should == '(Page: " x \\#{test :x => 1}")'
  end

  it 'should render file-elements' do
    doc = compile(File.read('example/hello.nag'))
    doc.should.not.be.empty
    xpath(doc, '//title').first.text.should == 'Hello, World!'
    xpath(doc, '//h1').first.text.should == 'Hello, World!'
  end
end
