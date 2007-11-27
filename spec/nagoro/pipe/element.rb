require 'spec/helper'

class Page < Nagoro::Element
  def render
    "(Page: #{@content.dump})"
  end
end

class SideBar < Nagoro::Element
  def render
    "(SideBar: #{@content.dump})"
  end
end

class Wrapper < Nagoro::Element
  def render
    %`
    <html>
      <head>
        <title>TodoList</title>
        <style>
          table     { width:       100%;              }
          tr        { background:  #efe; width: 100%; }
          tr:hover  { background:  #dfd;              }
          td.title  { font-weight: bold; width: 60%;  }
          td.status { margin:      1em;               }
          a         { color:       #3a3;              }
        </style>
      </head>
      <body>
        <h1>#{@title}</h1>
        <?r if flash[:error] ?>
          <div class="error">
            \#{flash[:error]}
          </div>
        <?r end ?>
        #{content}
      </body>
    </html>
    `
  end
end

class Task < Struct.new(:title, :status)
  def toggle
    '<a href="/toggle">toggle</a>'
  end
  def delete
    '<a href="/delete">delete</a>'
  end
end

describe 'Nagoro::Pipe::Element' do
  before :all do
    @nagoro = Nagoro::Template[:Element]
  end

  it 'should expand single element' do
    render('<Page />').
      should == '(Page: "")'
  end

  it 'should expand two elements' do
    render('<Page /><Page />').
      should == '(Page: "")(Page: "")'
  end

  it 'should expand nested elements' do
    render('<Page><Page /></Page>').
      should == '(Page: "(Page: "")")'
  end

  it 'should expand different nested elements' do
    render('<Page><SideBar /></Page>').
      should == '(Page: "(SideBar: "")")'
  end

  it 'should render nested <?r ?> correct in combination with #{} and Element' do
    @tasks = [
      Task.new('Wash dishes', false),
      Task.new('Vacuum', false)
    ]
    rendered = @nagoro.render(File.read(__DIR__/'template/nesting.nag'))
    # puts rendered.compiled
    doc = rendered.result(binding)
    doc.should_not be_empty
    xpath(doc, "//title").first.text.should == 'TodoList'
    xpath(doc, "//tr").should have(2).trs
    xpath(doc, "//tr/td").should have(8).tds
    xpath(doc, "//tr/td").first.text.should == 'Wash dishes'
  end

  def flash
    {}
  end
end
