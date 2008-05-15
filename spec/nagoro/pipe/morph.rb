require 'spec/helper'

describe "[#{Nagoro::ENGINE}] Nagoro::Pipe::Instruction" do
  def compile(obj)
    Nagoro::compile(obj, :pipes => :Morph).compiled
  end

  it 'should morph single tag' do
    compile('<a href="foo" if="1">bar</a>').
      should == '<?r if 1 ?><a href="foo">bar</a><?r end ?>'
  end

  it 'should morph multiple tags' do
    compile('<div if="2"><p if="1"></p></div>').
      should == '<?r if 2 ?><div><?r if 1 ?><p></p><?r end ?></div><?r end ?>'
  end

  it 'should morph if' do
    compile('<p if="1">x</p>').
      should == '<?r if 1 ?><p>x</p><?r end ?>'
  end

  it 'should morph unless' do
    compile('<p unless="1">x</p>').
      should == '<?r unless 1 ?><p>x</p><?r end ?>'
  end

  it 'should morph for' do
    compile('<p for="i in 1..10">#{i}</p>').
      should == '<?r for i in 1..10 ?><p>#{i}</p><?r end ?>'
  end

  it 'should morph each' do
    compile('<p each="1..10">#{_e}</p>').
      should == '<?r 1..10.each do |_e| ?><p>#{_e}</p><?r end ?>'
  end

  it 'should morph times' do
    compile('<p times="3">#{_t}</p>').
      should == '<?r 3.times do |_t| ?><p>#{_t}</p><?r end ?>'
  end

  it 'should morph filter' do
    compile('<p filter="my_filter">x</p>').
      should == '<?ro my_filter(%<<p>x</p>>) ?>'
  end
end
