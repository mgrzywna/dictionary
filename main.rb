require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

Slim::Engine.set_default_options pretty: true

get('/css/style.css') { scss :'styles/style' }

get '/' do
  slim :home
end
