require 'spec/helper'

describe "[#{Nagoro::ENGINE}] Nagoro::Listener::Base" do
  def base(string)
    nagoro = Nagoro::Template[:Base]
    nagoro.pipeline(string)
  end

  break unless Nagoro::ENGINE == :stringscanner

  it 'should not stumble over HTML entities' do
    %w[gt lt quot amp nbsp uuml].each do |entity|
      str = "&#{entity};" 
      base(str).should == str
    end
  end
end
