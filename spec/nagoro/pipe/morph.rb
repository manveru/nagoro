require 'spec/helper'

describe 'Nagoro::Pipe::Morph' do
  before :all do
    @nagoro = Nagoro::Template[:Morph]
  end

  it 'should morph single tag' do
    pipeline('<a href="foo" if="1">bar</a>').
      should == '<?r if 1 ?><a href="foo">bar</a><?r end ?>'
  end

  it 'should morph multiple tags' do
    pipeline('<div if="2"><p if="1" /></div>').
      should == '<?r if 2 ?><div><?r if 1 ?><p></p><?r end ?></div><?r end ?>'
  end

  it 'should not open/close JUST_CLOSE tags' do
    pipeline('<p><br /><br /></p>').
      should == '<p><br /><br /></p>'
  end

  it 'should not fail on html-entities' do
    pipeline('<html><head><title>&lt;&lt;</title></head></html>').
      should == '<html><head><title>&lt;&lt;</title></head></html>'
  end

  it 'should morph if' do
    pipeline('<p if="1">x</p>').
      should == '<?r if 1 ?><p>x</p><?r end ?>'
  end

  it 'should morph unless' do
    pipeline('<p unless="1">x</p>').
      should == '<?r unless 1 ?><p>x</p><?r end ?>'
  end

  it 'should morph for' do
    pipeline('<p for="i in 1..10">#{i}</p>').
      should == '<?r for i in 1..10 ?><p>#{i}</p><?r end ?>'
  end

  it 'should morph each' do
    pipeline('<p each="1..10">#{_e}</p>').
      should == '<?r 1..10.each do |_e| ?><p>#{_e}</p><?r end ?>'
  end

  it 'should morph times' do
    pipeline('<p times="3">#{_t}</p>').
      should == '<?r 3.times do |_t| ?><p>#{_t}</p><?r end ?>'
  end

  it 'should morph filter' do
    pipeline('<p filter="my_filter">x</p>').
      should == '#{my_filter(%<<p>x</p>>)}'
  end
end
