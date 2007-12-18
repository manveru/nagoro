require 'spec/helper'

describe 'Nagoro::Pipe::Compile' do
  before :all do
    @nagoro = Nagoro::Template[:Compile]
  end

  def pipeval(string)
    to_eval = pipeline(string)
    eval(to_eval.to_ruby)
  end

  it 'should compile a template' do
    pipeval('<?ro 1 ?>').should == '1'
  end

  it 'should compile a template with #{}' do
    pipeval('#{1 < 2}').should == 'true'
    pipeval('<p>#{1 + 1}</p>').should == '<p>2</p>'
  end
end

