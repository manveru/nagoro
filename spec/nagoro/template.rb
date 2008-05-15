require 'spec/helper'

describe "[#{Nagoro::ENGINE}] Nagoro" do
  it 'should ::compile from filename' do
    file = __DIR__/'template/hello.nag'
    template = Nagoro.compile(file)
    template.compiled.should == "_out_ = []; _out_ << %Q`Hello, World!\n`; _out_.join"
  end

  it 'should ::compile' do
    string = 'Hello, World!'
    template = Nagoro.compile(string)
    template.compiled.should == '_out_ = []; _out_ << %Q`Hello, World!`; _out_.join'
  end

  it 'should ::render from filename' do
    file = __DIR__/'template/hello.nag'
    rendered = Nagoro.render(file)
    rendered.should == File.read(file).strip
  end

  it 'should ::render' do
    string = 'Hello, World!'
    rendered = Nagoro.render(string)
    rendered.should == string
  end

  it 'should ::render from IO' do
    io = StringIO.new('Hello, World!')
    rendered = Nagoro.render(io)
    rendered.should == 'Hello, World!'
  end
end

describe "[#{Nagoro::ENGINE}] Nagoro::Template" do
  it 'should set up with ::[]' do
    template = Nagoro::Template[]
    template.pipes.should == []
    template = Nagoro::Template[*Nagoro::DEFAULT_PIPES]
    template.pipes.size.should == Nagoro::DEFAULT_PIPES.size
    template.pipes.each do |pipe|
      pipe.should.respond_to(:process)
    end
  end

  it 'should set up with ::new' do
    template = Nagoro::Template.new(:pipes => [])
    template.pipes.should.be.empty
    template = Nagoro::Template.new(:pipes => Nagoro::DEFAULT_PIPES)
    template.pipes.size.should == Nagoro::DEFAULT_PIPES.size
    template.pipes.each do |pipe|
      pipe.should.respond_to(:process)
    end
  end

  it 'should not open/close empty tags' do
    %w[ img hr br link meta ].each do |tag|
      tag = "<#{tag} />"
      Nagoro.render(tag).should == tag
    end
  end
end
