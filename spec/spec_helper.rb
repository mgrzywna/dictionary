# -*- encoding : utf-8 -*-

require 'rack/test'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require_relative '../app'
require_relative '../model'

set :run, false
set :raise_errors, true

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
