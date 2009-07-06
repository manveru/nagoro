require File.expand_path('../../helper', __FILE__)

describe "Nagoro" do
  should '::compile from filename' do
    file = __DIR__/'template/hello.nag'
    template = Nagoro.compile(file)
    template.compiled.should == "_out_ = []; _out_ << %Q`Hello, World!\n`; _out_.join"
  end

  should '::compile' do
    string = 'Hello, World!'
    template = Nagoro.compile(string)
    template.compiled.should == '_out_ = []; _out_ << %Q`Hello, World!`; _out_.join'
  end

  should 'compile <?end ?> to <?r end ?>' do
    string = '<?end ?>'
    template = Nagoro.compile(string)
    template.compiled.should == '_out_ = []; _out_ << %Q``;end; _out_ << %Q``; _out_.join'
  end

  should '::render from filename' do
    file = __DIR__/'template/hello.nag'
    rendered = Nagoro.render(file)
    rendered.should == File.read(file).strip
  end

  should '::render' do
    string = 'Hello, World!'
    rendered = Nagoro.render(string)
    rendered.should == string
  end

  should '::render from IO' do
    io = StringIO.new('Hello, World!')
    rendered = Nagoro.render(io)
    rendered.should == 'Hello, World!'
  end

  should 'render a full featured template with binding' do
    file = __DIR__/'template/full.nag'
    @title = 'Full template'

    template = Nagoro.render(file, :binding => binding)

    template.should =~ %r~<!DOCTYPE html PUBLIC~
    template.should =~ %r~<title>Full template</title>~
    template.should =~ %r~<h1>Full template</h1>~
  end
end

describe "Nagoro::Template" do
  should 'set up with ::[]' do
    template = Nagoro::Template[]
    template.pipes.should == []
    template = Nagoro::Template[*Nagoro::DEFAULT_PIPES]
    template.pipes.size.should == Nagoro::DEFAULT_PIPES.size
  end

  should 'set up with ::new' do
    template = Nagoro::Template.new(:pipes => [])
    template.pipes.should.be.empty
    template = Nagoro::Template.new(:pipes => Nagoro::DEFAULT_PIPES)
    template.pipes.size.should == Nagoro::DEFAULT_PIPES.size
  end

  should 'not open/close empty tags' do
    %w[ img hr br link meta ].each do |tag|
      tag = "<#{tag} />"
      Nagoro.render(tag).should == tag
    end
  end

  should 'render and pass result to tidy via #tidy_result' do
    template = Nagoro::Template.new
    template.compile('<html></html>').tidy_result.should ==
"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"
    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">

<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
  <title></title>
</head>

<body>
</body>
</html>"
  end

  def noop(*args) end

  it "doesn't get stuck when ruby contains double-quotes" do
    tag = %q(<link href='#{ noop("some.thing") }' />)
    Nagoro.render(tag, :binding => binding).should == "<link href='' />"
  end

  it "ignores comments" do
    comment = '
<!--[if IE]>
  <link rel="stylesheet" type="text/css" media="screen, projection" href="css/blueprint/ie.css">
<![endif]-->'.strip

    Nagoro.render(comment).should == comment
  end

  it "ignores javascript in parameter" do
    @stuff = 'nothing'
    tag = %q|<a href="stuff" onmouseover='this.src="#{@stuff}"'>stuff</a>|

    Nagoro.render(tag, :binding => binding).should == %|<a href="stuff" onmouseover='this.src="#{@stuff}"'>stuff</a>|
  end

  it 'The param tag should be left open if it is not closed' do
    Nagoro.render('<param><tag>foo</tag></param>').should == '<param><tag>foo</tag></param>'
  end
end
