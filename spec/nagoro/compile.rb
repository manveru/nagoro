require 'spec/helper'

describe 'Nagoro::Render' do
  before :all do
    @nagoro = Nagoro::Template[Nagoro::DEFAULT_PIPES]
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
    render('<br />')
      should == '<br />'
  end

  it 'should not fail on html-entities' do
    pipeline('<html><head><title>&lt;&lt;</title></head></html>').
      should == '<html><head><title>&lt;&lt;</title></head></html>'
  end
end
