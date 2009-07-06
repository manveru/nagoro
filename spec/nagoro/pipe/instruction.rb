require File.expand_path('../../../helper', __FILE__)

describe "Nagoro::Pipe::Instruction" do
  behaves_like 'xpath'
  def compile(obj)
    Nagoro::Template[Nagoro::Pipe::Instruction].compile(obj).compiled
  end

  it 'should expand <?js code ?>' do
    compile('<?js alert("Hello, World!"); ?>').
      should == '<script type="text/javascript"> alert("Hello, World!"); </script>'
  end

  it 'should expand <?js:src path?>' do
    doc = compile('<?js:src /js/foo.js ?>')
    scripts = xpath(doc, 'script[@type="text/javascript" @src="/js/foo.js"]')
    scripts.size.should == 1
    scripts.first.texts.should.be.empty
  end

  it 'should expand <?css styles ?>' do
    compile('<?css body{ color: #eee; } ?>').
      should == '<style type="text/css"> body{ color: #eee; } </style>'
  end

  it 'should expand <?css:src path ?>' do
    doc = compile('<?css:src /css/foo.css ?>')
    styles = xpath(doc, 'style[@type="text/css" @src="/css/foo.css"]')
    styles.size.should == 1
    styles.first.texts.should.be.empty
  end
end
