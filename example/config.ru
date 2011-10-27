require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-mixi'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/mixi'
  end

  get '/mixi_tabs/publishing' do
    redirect "/auth/mixi/callback?code=#{params[:code]}"
  end
  
  get '/auth/:provider/callback' do
    content_type 'application/json'
    puts request.env['omniauth.auth']
    MultiJson.encode({'success' => 'foo'})
  end
  
  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode({'fail' => 'bar'})
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :mixi, '04e470753a4231e41532', '0a7bbc14b48fda308d95f360dc41f6aa5f92e103'
end

run App.new
