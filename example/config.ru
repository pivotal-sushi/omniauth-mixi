require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-mixi'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/mixi'
  end

  get '/mixi_tabs/publishing' do
    raise "The callback has changed to /auth/mixi/callback"
    redirect "/auth/mixi/callback?code=#{params[:code]}"
  end
  
  get '/mixi_tabs/you_tube_config' do
    content_type 'application/json'
    puts "*********************************"
    puts request.env['omniauth.auth']
    puts "*********************************"
    MultiJson.encode({'success' => 'foo'})
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    puts "*********************************"
    puts request.env['omniauth.auth']
    puts "*********************************"
    MultiJson.encode({'success' => 'foo'}.merge(request.env['omniauth.auth']))
  end
  
  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode({'fail' => 'bar'})
  end

  get '/auth/mixi/setup' do
    #app from external spec
    #request.env['omniauth.strategy'].options.client_id = '1d55b428360e582e7904'
    #request.env['omniauth.strategy'].options.client_secret = 'd3bdc3034846e701151ab1007c12860a0c459c30'
    request.env['omniauth.strategy'].options.client_id = '04e470753a4231e41532'
    request.env['omniauth.strategy'].options.client_secret = '0a7bbc14b48fda308d95f360dc41f6aa5f92e103'
    status 404
    "DONE"
  end

end

use Rack::Session::Cookie

use OmniAuth::Builder do

#youtube app
#provider :mixi, 'bc305ea06cf326332066', '2cf72ec7c43e1a43876a553fdbbec523291764a4'

#publishing app
#  provider :mixi, '04e470753a4231e41532', '0a7bbc14b48fda308d95f360dc41f6aa5f92e103'

  provider :mixi, nil, nil, :setup => true
end
run App.new

