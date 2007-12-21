require 'spec/helper'

describe 'Nagoro::Pipe::Instruction' do
  def compile(obj)
    Nagoro::compile(obj, :pipes => :Instruction).compiled
  end

  it 'should expand <?js code ?>' do
    compile('<?js alert("Hello, World!"); ?>').
      should == '<script type="text/javascript"> alert("Hello, World!"); </script>'
  end

  it 'should expand <?js:src path?>' do
    doc = compile('<?js:src /js/foo.js ?>')
    scripts = xpath(doc, 'script[@type="text/javascript" @src="/js/foo.js"]')
    scripts.should have(1).element
    scripts.first.texts.should be_empty
  end

  it 'should expand <?css styles ?>' do
    compile('<?css body{ color: #eee; } ?>').
      should == '<style type="text/css"> body{ color: #eee; } </style>'
  end

  it 'should expand <?css:src path ?>' do
    doc = compile('<?css:src /css/foo.css ?>')
    styles = xpath(doc, 'style[@type="text/css" @src="/css/foo.css"]')
    styles.should have(1).element
    styles.first.texts.should be_empty
  end
end
