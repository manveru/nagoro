require 'lib/nagoro'
require 'spec'

describe 'Nagoro::Listener::Morpher' do
  before :all do
    @nagoro = Nagoro::Template[:Morpher]
  end

  def morph(string)
    @nagoro.pipeline(string)
  end

  it 'should morph single tag' do
    morph('<a href="foo" if="1">bar</a>').
      should == '<?r if 1 ?><a href="foo">bar</a><?r end ?>'
  end

  it 'should morph multiple tags' do
    morph('<div if="2"><p if="1" /></div>').
      should == '<?r if 2 ?><div><?r if 1 ?><p></p><?r end ?></div><?r end ?>'
  end
end
