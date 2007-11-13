require 'spec/helper'

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

  it 'should expand single element' do
    render('<Page />').
      should == '(Page: "")'
  end

  it 'should expand two elements' do
    render('<Page /><Page />').
      should == '(Page: "")(Page: "")'
  end

  it 'should expand nested elements' do
    render('<Page><Page /></Page>').
      should == '(Page: "(Page: "")")'
  end

  it 'should expand different nested elements' do
    render('<Page><SideBar /></Page>').
      should == '(Page: "(SideBar: "")")'
  end
end
