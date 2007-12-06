require 'spec/helper'

unless defined?(Html)
  class Html < Nagoro::FileElement("example/element/Html.nage")
  end
end

describe 'Nagoro::Render' do
  before :all do
    @nagoro = Nagoro::Template[:Element, :Morph, :Include, :Instruction]
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
    pipeline('<?r i = 2 ?>#{i * i}').
      should == '<?r i = 2 ?>#{i * i}'
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

  it 'should render various doctypes' do
    [ '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
    ].each do |doctype|
      render('<?xml version="1.0" ?>' + doctype + '<html></html>')
    end
  end

  it 'should not open/close JUST_CLOSE tags' do
    pipeline('<p><br /><br /></p>').
      should == '<p><br /><br /></p>'
  end

  it 'should not fail on html-entities' do
    pipeline('<html><head><title>&lt;&lt;</title></head></html>').
      should == '<html><head><title>&lt;&lt;</title></head></html>'
  end
end
