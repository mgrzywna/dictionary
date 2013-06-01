# -*- encoding : utf-8 -*-

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require './model'

Slim::Engine.set_default_options pretty: true

$navigation = {
  :'' => 'HOME',
  :add => 'ADD TRANSLATION',
  :editlang => 'EDIT LANGUAGES'
}

get('/css/style.css') { scss :'styles/style' }

get '/' do
  @active_page = :''
  slim :search_form
end

get '/search' do
  @words = Word.all(:name.like => "#{params[:word]}")
  slim :search
end

get '/add' do
  @languages = Language.all
  @active_page = :add
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
  @active_page = :editlang
  slim :editlang
end

get '/word/:word' do
end
