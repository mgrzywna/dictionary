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
  component :search_form
end

get '/search' do
  word = params[:word].split.join(' ')
  @words = Word.all(:name.like => "#{word}")
  slim :search
end

get '/add' do
  @languages = Language.all
  component :add_word_form, :action => '/add', :label => 'Add word'
end

post '/add' do
  redirect '/edit'
end

get '/edit' do
end

post '/edit' do
  redirect '/edit'
end

get '/edit-languages' do
end

get '/word/:word' do
end

helpers do
  def component(name, locals=nil)
      slim "components/".concat(name.to_s).to_sym, :locals => locals
  end
end
