require 'lib/nagoro'
require 'spec'

describe 'Nagoro::Listener::Instruction' do
  before :all do
    @nagoro = Nagoro::Template[:Instruction]
  end

  def instruction(string)
    @nagoro.pipeline(string)
  end

  it 'should expand <?js ?>' do
    instruction('<?js alert("Hello, World!"); ?>').
      should == '<script type="text/javascript"> alert("Hello, World!"); </script>'
  end

  it 'should expand <?js:path?>' do
    instruction('<?js:/js/foo.js?>').
      should == '<script type="text/javascript" src="/js/foo.js"></script>'
  end

  it 'should expand <?css ?>' do
    instruction('<?css body{ color: #eee; } ?>').
      should == '<style type="text/css"> body{ color: #eee; } </style>'
  end

  it 'should expand <?css:path?>' do
    instruction('<?css:/css/foo.css?>').
      should == '<style type="text/css" src="/css/foo.css"></style>'
  end

  it 'should expand <?n.times ?>' do
    instruction('<?2.times Hello ?>').
      should == '<?r 2.times do ?> Hello <?r end ?>'
  end
end
