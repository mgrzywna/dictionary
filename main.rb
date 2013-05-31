require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  'Lorem ipsum dolor sit amet'
end
