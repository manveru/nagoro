require 'spec/helper'
require 'nagoro/pipe/tidy'

describe "Nagoro::Pipe::Tidy" do
  behaves_like 'xpath'

  def compile(obj)
    Nagoro::Template[Nagoro::Pipe::Tidy].compile(obj).compiled
  end

  it 'pipes the template through tidy' do
    compile('<html></html').strip.should == 
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
end
