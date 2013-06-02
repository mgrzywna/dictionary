require_relative '../main'
require_relative '../model'

require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end
