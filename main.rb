# -*- encoding : utf-8 -*-

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require './model'

Slim::Engine.set_default_options pretty: true

$navigation = [
  ['/', 'HOME'],
  ['/add-word', 'ADD WORD']
]

get('/css/style.css') { scss :'styles/style' }

get '/' do
  component :search_form
end

get '/search' do
  word = params[:word].split.join(' ')
  @words = Word.all(:name.like => "%#{word}%")
  slim :search
end

get '/word/:word_id' do
  @word = Word.get(params[:word_id]) or halt(404)
  slim :word
end

get '/add-word' do
  @languages = Language.all
  component :add_word_form, :action => '/add-word', :label => 'Add word'
end

post '/add-word' do
  word = Word.add(params[:word], params[:language])
  redirect "/add-translation/#{word.id}"
end

get '/add-translation/:word_id' do
  @languages = Language.all
  @word = Word.get(params[:word_id]) or halt(404)
  slim :add_translation
end

post '/add-translation/:word_id' do
  translation = Word.add(params[:word], params[:language]) or halt(404)
  word = Word.get(params[:word_id]) or halt(404)
  TranslationPair.create(first: word, second: translation)
  TranslationPair.create(first: translation, second: word)
  redirect "/add-translation/#{word.id}"
end

get '/edit-languages' do
end

not_found do
  slim :not_found
end

helpers do
  def component(name, locals=nil)
      slim "components/".concat(name.to_s).to_sym, :locals => locals
  end
end
