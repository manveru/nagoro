require 'spec/helper'

describe "Nagoro::Pipe::Include" do
  def compile(obj)
    Nagoro::Template[Nagoro::Pipe::Include].compile(obj).compiled
  end

  it 'should append included file with arguments src or href' do
    path = __DIR__/'../template/hello.nag'

    compile(%{<p id="text"><include src="#{path}" /></p>}).strip.
      should == %{<p id="text">#{File.read(path).strip}</p>}

    compile(%{<p id="text"><include href="#{path}" /></p>}).strip.
      should == %{<p id="text">#{File.read(path).strip}</p>}
  end
end
