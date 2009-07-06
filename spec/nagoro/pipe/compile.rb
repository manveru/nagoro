require File.expand_path('../../../helper', __FILE__)

describe "Nagoro::Pipe::Compile" do
  def render(obj)
    Nagoro::Template[Nagoro::Pipe::Compile].render(obj)
  end

  should 'compile normal string' do
    render('Hello, World!').should == 'Hello, World!'
  end

  should 'compile ruby instructions' do
    render('<?r a = 1 ?><?ro a ?>').should == '1'
    render('<?r a = 1 ?><?ro a > 1 ?>').should == 'false'
    render('<?r a = 1 ?><?ro a < 1 ?>').should == 'false'
  end

  should 'compile with compatiblity to Ezamar' do
    render('<?r a = 1 ?>#{a}').should == '1'
    render('<?r a = 1 ?>#{a > 1}').should == 'false'
    render('<?r a = 1 ?>#{a < 1}').should == 'false'
  end

  should 'not fail on nested {} inside #{}' do
    render('#{"Hello, {World}!"}').should == 'Hello, {World}!'
  end

  should 'not fail on > inside ruby instruction' do
    render('#{{:hi => :there}[:hi]}').should == 'there'
  end
end
