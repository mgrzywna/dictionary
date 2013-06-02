require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../main'
require_relative '../model'

set :run, false
set :raise_errors, true

def app
  Sinatra::Application
end
