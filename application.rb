require 'sinatra/base'
require 'sinatra/assetpack'
require 'haml'
require 'sass'
require 'httparty'
require 'json'

class Application < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sass, { :load_paths => [ "#{Application.root}/assets/stylesheets" ] }

  register Sinatra::AssetPack

  assets {
    serve '/css', from: 'assets/stylesheets'
    serve '/images', from: 'assets/images'
    serve '/js', from: 'assets/javascripts'
    serve '/fonts', from: 'assets/fonts'

    css :application, '/css/application.css', %w(/css/reset.css /css/index.css /css/modal.css /css/current.css)
    js :application, '/js/application.js', %w( /js/jquery-1.9.1.js  /js/order.js /js/google_maps.js)

    css_compression :sass
    js_compression :jsmin
  }

  get '/' do
    haml :index
  end

  post '/orders.json' do

    phones = %w(79163808020)

    message = "#{params[:order][:username]}. #{params[:order][:phone]}"

    phones.each do |phone|
      HTTParty.get(
          'http://api.sms24x7.ru',
          query: {
              method: 'push_msg',
              email: 'agatovs@gmail.com',
              password: 'avv6rqE',
              phone: phone.to_s,
              text: message,
              sender_name: 'gorkom5'
          }
      )
    end

    content_type :json
    {status: :success}.to_json
  end
end