require 'spec/helper'

describe 'Nagoro::Pipe::Element' do
  def compile(obj)
    Nagoro::compile(obj, :pipes => :Element).compiled
  end

  before :all do
    Nagoro.element('Page') do |content, attrs|
      "(Page: #{content.dump})"
    end
    Nagoro.element('SideBar') do |content, attrs|
      "(SideBar: #{content.dump})"
    end
    Nagoro.file_element('Html', 'example/element/Html.nage')
  end

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

  it 'should render file-elements' do
    doc = compile('example/hello.nag')
    doc.should_not be_empty
    xpath(doc, '//title').first.text.should == 'Hello, World!'
    xpath(doc, '//h1').first.text.should == 'Hello, World!'
  end
end
