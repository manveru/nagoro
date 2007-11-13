require 'spec/helper'

describe 'Nagoro::Listener::Instruction' do
  before :all do
    @nagoro = Nagoro::Template[:Instruction]
  end

  it 'should expand <?js ?>' do
    pipeline('<?js alert("Hello, World!"); ?>').
      should == '<script type="text/javascript"> alert("Hello, World!"); </script>'
  end

  it 'should expand <?js:path?>' do
    pipeline('<?js:/js/foo.js?>').
      should == '<script type="text/javascript" src="/js/foo.js"></script>'
  end

  it 'should expand <?css ?>' do
    pipeline('<?css body{ color: #eee; } ?>').
      should == '<style type="text/css"> body{ color: #eee; } </style>'
  end

  it 'should expand <?css:path?>' do
    pipeline('<?css:/css/foo.css?>').
      should == '<style type="text/css" src="/css/foo.css"></style>'
  end

  it 'should expand <?n.times ?>' do
    pipeline('<?2.times Hello ?>').
      should == '<?r 2.times do ?> Hello <?r end ?>'
  end
end
