# -*- encoding : utf-8 -*-

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require './model'

Slim::Engine.set_default_options pretty: true

$navigation = [
  ['/', 'HOME'],
  ['/add', 'ADD TRANSLATION'],
  ['/editlang', 'EDIT LANGUAGES']
]

get('/css/style.css') { scss :'styles/style' }

get '/' do
  slim :search_form
end

get '/search' do
  word = params[:word].split.join(' ')
  @words = Word.all(:name.like => "#{word}")
  slim :search
end

get '/add' do
  @languages = Language.all
  slim :add
end

post '/add' do
  redirect '/edit'
end

get '/edit' do
  slim :edit
end

post '/edit' do
  redirect '/edit'
end

get '/editlang' do
  slim :editlang
end

get '/word/:word' do
end

helpers do
  def component(name, locals)
      slim "components/".concat(name.to_s).to_sym, :locals => locals
  end
end
