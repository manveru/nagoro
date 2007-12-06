require 'spec/helper'

describe('Error'){
  def check(string)
    Nagoro.render(string)
  end

  xml_decl = '<?xml version="1.0" encoding="utf-8"?>'
  doctype = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
  doctype = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'

  { Nagoro::Error::Parse::StartTag => {
      '<' => 'invalid element name',
    },
    Nagoro::Error::Parse => {
      '<p' => 'error parsing attribute name',
      '</p' => "expected '>'",
      '<p>' => 'Opening and ending tag mismatch: p line 0 and nagoro',
      '</p>' => 'Opening and ending tag mismatch: nagoro line 0 and p',
      '<p foo' => 'Specification mandate value for attribute foo',
      '<p </p>' => "error parsing attribute name",
      '<p foo</p>' => 'Specification mandate value for attribute foo',
      '<p class></p>' => 'Specification mandate value for attribute class',
      '<p class=></p>' => "AttValue: \" or ' expected",
      '<p class="></p>' => "Unescaped '<' not allowed in attributes values",
      '<p class""></p>' => 'Specification mandate value for attribute class',
      # xml_decl => "Start tag expected, '<' not found",
      ']]>' => "Sequence ']]>' not allowed in content",
      # '<![CDATA[' => "CData section not finished\n</nagor",
      '<?xml ' => 'Malformed declaration expecting version',
    },
    Nagoro::Error::Parse::PI => {
      '<?x' => 'PI x space expected',
      '<?x ' => 'PI x never end ...',
    },
  }.each do |error_class, markup_message|
    markup_message.each do |markup, message|
      it "should complain for '#{markup}' with '#{message}'" do
        lambda{ check(markup) }.
          should raise_error(error_class, message)
      end
    end
  end

  [ "#{xml_decl}#{doctype}<html>foo</html>",
  ].each do |markup|
    it "should not raise error on: #{markup}" do
      lambda{ check(markup) }.should_not raise_error
    end
  end
} unless Nagoro::ENGINE == :rexml
