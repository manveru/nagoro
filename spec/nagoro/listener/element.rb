require 'lib/nagoro'
require 'spec'

class Page < Nagoro::Element
  def render
    "(Page: #{@content.dump})"
  end
end

class SideBar < Nagoro::Element
  def render
    "(SideBar: #{@content.dump})"
  end
end

describe 'Nagoro::Listener::Element' do
  before :all do
    @nagoro = Nagoro::Template[:Element]
  end

  def element(string)
    template = @nagoro.render(string)
    template.result(binding)
  end

  it 'should expand single element' do
    element('<Page />').
      should == '(Page: "")'
  end

  it 'should expand two elements' do
    element('<Page /><Page />').
      should == '(Page: "")(Page: "")'
  end

  it 'should expand nested elements' do
    element('<Page><Page /></Page>').
      should == '(Page: "(Page: "")")'
  end

  it 'should expand different nested elements' do
    element('<Page><SideBar /></Page>').
      should == '(Page: "(SideBar: "")")'
  end
end
