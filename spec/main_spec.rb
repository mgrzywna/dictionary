# -*- encoding : utf-8 -*-

require "spec_helper"

describe "Dictionary" do
  include Rack::Test::Methods

  before :each do
    @english = Language.first_or_create(name: "English")
    @polish = Language.first_or_create(name: "Polish")
  end

  describe "get /" do
    it "should load the home page" do
      get "/"
      last_response.should be_ok
    end
  end

  describe "get /search" do
    it "should redirect to / when given empty word" do
      get "/search", word: ""
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should == "http://example.org/"
    end

    it "should show message when it can't find given word" do
      get "/search", word: "lorem ipsum"
      last_response.should be_ok
      last_response.body.should match /Unfortunately we can't find/
    end

    it "should show a translation of a word" do
      en = Word.first_or_create(name: "water", language: @english)
      pl = Word.first_or_create(name: "woda", language: @polish)
      TranslationPair.create(first: en, second: pl)

      get "/search", word: "water"
      last_response.should be_ok
      last_response.body.should match /woda/
    end

    it "should remove extra whitespace when searching" do
      en = Word.first_or_create(name: "ball pen", language: @english)
      pl = Word.first_or_create(name: "długopis", language: @polish)
      TranslationPair.create(first: pl, second: en)

      get "/search", word: "  ball  pen  "
      last_response.should be_ok
      last_response.body.should match /ball pen/
    end
  end

  describe "not found" do
    it "should give 404" do
      get "/something"
      last_response.status.should == 404
      last_response.body.should match /Go to the homepage/
    end
  end
end
