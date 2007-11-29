require 'spec/helper'

describe 'Nagoro::Pipe::Instruction' do
  before :all do
    @nagoro = Nagoro::Template[:Instruction]
  end

  def instruction(string)
    pipeline("<p>#{string}</p>")[3..-5]
  end

  it 'should expand <?js ?>' do
    instruction('<?js alert("Hello, World!"); ?>').
      should == '<script type="text/javascript"> alert("Hello, World!"); </script>'
  end

  it 'should expand <?js:path?>' do
    instruction('<?js:src /js/foo.js ?>').
      should == '<script type="text/javascript" src="/js/foo.js"></script>'
  end

  it 'should expand <?css ?>' do
    instruction('<?css body{ color: #eee; } ?>').
      should == '<style type="text/css"> body{ color: #eee; } </style>'
  end

  it 'should expand <?css:path?>' do
    instruction('<?css:src /css/foo.css ?>').
      should == '<style type="text/css" src="/css/foo.css"></style>'
  end
end
