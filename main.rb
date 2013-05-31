require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require './model'

Slim::Engine.set_default_options pretty: true

get('/css/style.css') { scss :'styles/style' }

get '/' do
  slim :search_form
end

get '/search' do
  @words = Word.all(:name.like => "#{params[:word]}")
  slim :search
end
