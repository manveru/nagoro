require 'lib/nagoro'
require 'nagoro/transformer/localization'
require 'spec'

describe 'Nagoro::Transformer::Localization' do
  before :all do
    Nagoro::Listener::Localization[
      :locales => %w[en de jp]
    ]
    @nagoro = Nagoro::Template[:Localization]
    @localization = @nagoro.listeners.first
    @localization.dict = {
      'en' => {'moin' => 'Hello'},
      'jp' => {'moin' => 'こんいちわ'},
      'de' => {'moin' => 'Guten Tag'},
    }
  end

  def render(string)
    template = @nagoro.render(string)
    template.result(binding)
  end

  it 'should translate simple string' do
    @localization.dict.each do |locale, dict|
      @localization.locale = locale
      render('[[moin]]').
        should == dict['moin']
    end
  end

  after :all do
    FileUtils.rm_rf('config')
  end
end
