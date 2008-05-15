require 'spec/helper'

describe "[#{Nagoro::ENGINE}] Nagoro::Pipe::Include" do
  def compile(obj)
    Nagoro::compile(obj, :pipes => :Include).compiled
  end

  it 'should append included file with arguments src or href' do
    path = __DIR__/'../template/hello.nag'

    compile(%{<p id="text"><include src="#{path}" /></p>}).
      should == %{<p id="text">#{File.read(path).strip}</p>}

    compile(%{<p id="text"><include href="#{path}" /></p>}).
      should == %{<p id="text">#{File.read(path).strip}</p>}
  end
end
