require 'spec_helper'
require 'omniauth-mixi'

describe OmniAuth::Strategies::Mixi do
  subject do
    OmniAuth::Strategies::Mixi.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'has correct Mixi site' do
      subject.client.site.should eq('https://secure.mixi-platform.com')
    end

    it 'has correct authorize url' do
      subject.client.options[:authorize_url].should eq('https://mixi.jp/connect_authorize.pl')
    end

    it 'has correct token url' do
      subject.client.options[:token_url].should eq('https://secure.mixi-platform.com/2/token')
    end
  end

  describe '#token_params' do
    it 'has correct parse strategy' do
      subject.token_params[:parse].should eq(:json)
    end
  end

  describe '#callback_path' do
    it "has the correct callback path" do
      subject.callback_path.should eq('/mixi_tabs/publishing')
    end
  end
  describe '#authorize_params' do
    it "has some authorize_params" do
      subject.authorize_params.should_not be_empty
    end
  end
end
