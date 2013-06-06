# -*- encoding : utf-8 -*-

require 'slim'
require 'sass'
require 'data_mapper'

require 'sinatra' unless defined?(Sinatra)

configure :production do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")
  DataMapper::Model.raise_on_save_failure = false
  Slim::Engine.set_default_options :pretty => false
end

configure :test do
  DataMapper.setup(:default, "sqlite::memory:")
  DataMapper::Model.raise_on_save_failure = true
  Slim::Engine.set_default_options :pretty => true
end

configure :development do
  require 'sinatra/reloader'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper::Model.raise_on_save_failure = true
  Slim::Engine.set_default_options :pretty => true
end
