require 'spec/helper'

describe "example/hello.nag" do
  behaves_like 'xpath'

  Nagoro.file_element('Html', 'example/element/Html.nage')

  should 'render Hello, World!' do
    file = 'example/hello.nag'
    doc = Nagoro.compile(file, :pipes => [:Element]).compiled
    xpath(doc, '//title').first.text.should == 'Hello, World!'
  end
end
