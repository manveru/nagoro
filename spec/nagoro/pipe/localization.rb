require 'spec/helper'
require 'nagoro/pipe/localization'

describe 'Nagoro::Transformer::Localization' do
  before :all do
    Nagoro::Pipe::Localization[
      :locales => %w[en de jp]
    ]
    @nagoro = Nagoro::Template[:Localization]
    @localization = @nagoro.pipes.first
    @localization.dict = {
      'en' => {'moin' => 'Hello'},
      'jp' => {'moin' => 'こんいちわ'},
      'de' => {'moin' => 'Guten Tag'},
    }
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
