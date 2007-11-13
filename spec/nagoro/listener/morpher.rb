require 'spec/helper'

describe 'Nagoro::Listener::Morpher' do
  before :all do
    @nagoro = Nagoro::Template[:Morpher]
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
    pipeline('<br /><br/>').
      should == '<br /><br />'
  end

  it 'should not fail on html-entities' do
    pipeline('<html><head><title>&lt;&lt;</title></head></html>').
      should == '<html><head><title>&lt;&lt;</title></head></html>'
  end
end
