require 'spec/helper'

describe 'Nagoro::render' do
  def render(obj)
    Nagoro.render(obj)
  end

  it 'should render' do
    render('<?r i = 2 ?><?ro i * i ?>').should == '4'
  end

  it 'should not open/close JUST_CLOSE tags' do
    render('<br />').should == '<br />'
  end
end

__END__

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

  it 'should not fail on html-entities' do
    pipeline('<html><head><title>&lt;&lt;</title></head></html>').
      should == '<html><head><title>&lt;&lt;</title></head></html>'
  end
end
