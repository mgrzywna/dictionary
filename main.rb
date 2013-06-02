# -*- encoding : utf-8 -*-

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require './model'

Slim::Engine.set_default_options pretty: true

get('/css/style.css') { scss :'styles/style' }
not_found { slim :not_found }

get '/' do
  slim :'components/search_form'
end

get '/search' do
  word = params[:word].split.join(' ')
  if word.empty? then redirect '/' end
  words = Word.all :name.like => "%#{word}%", :limit => 30
  @words = words.select { |word| word.translations.count > 0 }
  slim :search
end

get '/word/:word_id' do
  @word = Word.get(params[:word_id]) or halt(404)
  slim :word
end

get '/add-word' do
  @languages = Language.all
  @form = {
    :action => '/add-word',
    :label => 'Add word',
    :input_name => 'word'
  }
  slim :'components/add_word_form'
end

post '/add-word' do
  language = Language.get params[:language]
  word = Word.first_or_create :name => params[:word], :language => language
  redirect "/add-translation/#{word.id}"
end

get '/add-translation/:word_id' do
  @word = Word.get(params[:word_id]) or halt(404)
  @languages = Language.all
  @form = {
    :action => "/add-translation/#{@word.id}",
    :label => 'Add translation',
    :input_name => 'translation'
  }
  slim :add_translation
end

post '/add-translation/:word_id' do
  word = Word.get params[:word_id]
  language = Language.get params[:language]
  translation = Word.first_or_create :name => params[:translation], :language => language
  TranslationPair.create :first => word, :second => translation
  TranslationPair.create :first => translation, :second => word
  redirect "/add-translation/#{word.id}"
end

post '/add-language' do
  language = params[:language].split.join(' ')
  unless language.empty?
    Language.first_or_create :name => params[:language]
  end
  redirect "#{params[:redirect]}"
end
