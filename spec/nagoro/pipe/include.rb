require 'spec/helper'

module Kernel
  unless defined?__DIR__
    def __DIR__()
      filename = caller[0][/(.*?):/, 1]
      File.expand_path(File.dirname(filename))
    end
  end
end

class String
  def / obj
    File.join(self, obj.to_s)
  end
end


describe 'Nagoro::Pipe::Element' do
  before :all do
    @nagoro = Nagoro::Template[:Include]
  end

  it 'should comment errors' do
    render('<include src="" />').
      should == '<!-- No such file or directory -  -->'
    render('<include src="nosuchfile" />').
      should == '<!-- No such file or directory - nosuchfile -->'
    render('<include src="/" />').
      should == '<!-- Is a directory - / -->'
  end

  it 'should include files' do
    path = __DIR__/'include/hello.nag'
    render("<body><include src='#{path}' /></body>").
      should == '<body><h1>Hello, World!</h1></body>'
  end
end
