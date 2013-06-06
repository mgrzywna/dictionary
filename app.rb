# -*- encoding : utf-8 -*-

require 'sinatra'

require './environment'
require './model'

DataMapper.auto_upgrade!

get('/css/style.css') { scss :'styles/style' }
not_found { slim :not_found }


get '/' do
  slim :'components/search_form'
end


get '/search' do
  word = params[:word].split.join(' ')

  if word.empty?
    redirect '/'
  end

  @words = Word.all :name.like => "%#{word}%", :limit => 30
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
  word = params[:word].split.join(' ')

  if word.empty?
    redirect '/add-word'
  end

  word = Word.first_or_create :name => word, :language => language
  redirect "/add-translation/#{word.id}"
end


get '/add-translation/:word_id' do
  @word = Word.get(params[:word_id])  or halt(404)
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
  translation = params[:translation].split.join(' ')

  if translation.empty?
    redirect "/add-translation/#{word.id}"
  end

  translation = Word.first_or_create :name => translation, :language => language
  word.add_translation(translation)
  redirect "/add-translation/#{word.id}"
end


post '/add-language' do
  language = params[:language].split.join(' ')

  unless language.empty?
    Language.first_or_create :name => params[:language]
  end

  redirect "#{params[:redirect]}"
end
