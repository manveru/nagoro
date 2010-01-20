require File.expand_path('../../../helper', __FILE__)

describe "Nagoro::Pipe::Element" do
  behaves_like 'xpath'

  def compile(obj)
    Nagoro::Template[Nagoro::Pipe::Element].compile(obj).compiled
  end

  def help_func(attrs={:key => "value"})
    "--#{attrs[:key]}--"
  end

  Nagoro.element('Page') do |content, attrs|
    "(Page: #{content.dump})"
  end

  Nagoro.element('SideBar') do |content, attrs|
    "(SideBar: #{content.dump})"
  end

  Nagoro.file_element('Html', 'example/element/Html.nage')

  it 'should compile single element' do
    compile('<Page />').
      should == '(Page: "")'
  end

  it 'should compile two elements' do
    compile('<Page /><Page />').
      should == '(Page: "")(Page: "")'
  end

  it 'should compile nested elements' do
    compile('<Page><Page /></Page>').
      should == '(Page: "(Page: \\"\\")")'
  end

  it 'should compile different nested elements' do
    compile('<Page><SideBar /></Page>').
      should == '(Page: "(SideBar: \\"\\")")'
  end

  it 'should compile function' do
    ::Nagoro.render('#{help_func}', :binding => binding).
      should == '--value--'
  end

  it 'should compile hash argument' do
    ::Nagoro.render('#{help_func :key => "fail"}', :binding => binding).
      should == '--fail--'
  end

  it 'should compile nested function' do
    ::Nagoro.render('<Page>#{help_func}</Page>', :binding => binding).
      should == '(Page: "--value--")'
  end

  it 'should compile nested hash argument' do
    ::Nagoro.render('<Page>#{help_func :key => "fail"}</Page>', :binding => binding).
      should == '(Page: "--fail--")'
  end

  it 'should compile nested nested hash argument' do
    ::Nagoro.render('<Page><SideBar>#{help_func :key => "fail"}</SideBar></Page>').
      should == '(Page: "(SideBar: \\"--fail--\\")")'
  end

  it 'should render file-elements' do
    doc = compile(File.read('example/hello.nag'))
    doc.should.not.be.empty
    xpath(doc, '//title').first.text.should == 'Hello, World!'
    xpath(doc, '//h1').first.text.should == 'Hello, World!'
  end
end
