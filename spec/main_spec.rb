require 'spec_helper'

describe 'Sinatra Application' do
  include Rack::Test::Methods

  it 'should load the home page' do
    get '/'
    last_response.should be_ok
  end
end
