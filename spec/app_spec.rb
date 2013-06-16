# -*- encoding : utf-8 -*-

require "spec_helper"

describe "Dictionary" do
  include Rack::Test::Methods

  before :each do
    @english = Language.first_or_create(name: "English")
    @polish = Language.first_or_create(name: "Polish")
  end

  describe "not found" do
    it "should give 404" do
      get "/something"
      last_response.status.should == 404
      last_response.body.should match /Go to the homepage/
    end
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

    it "should redirect to / when given no word" do
      get "/search"
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
      en.add_translation(pl)

      get "/search", word: "  ball  pen  "
      last_response.should be_ok
      last_response.body.should match /ball pen/
    end
  end

  describe "get /word/:word_id" do
    it "should show word" do
      foo = Word.first_or_create(name: "foo", language: @english)
      get "/word/#{foo.id}"
      last_response.should be_ok
      last_response.body.should match /foo/

      bar = Word.first_or_create(name: "bar", language: @english)
      get "/word/#{bar.id}"
      last_response.should be_ok
      last_response.body.should match /bar/
    end

    it "should give 404 when word cannot be found" do
      get "/word/123"
      last_response.status.should == 404
    end
  end

  describe "get /add-word" do
    it "should show form" do
      get "/add-word"
      last_response.should be_ok
      last_response.should match /<form/
    end
  end

  describe "post /add-word" do
    it "should create a new word" do
      post "/add-word", language: @english.id, word: "guitar"
      word = Word.first
      word.name.should == "guitar"
      follow_redirect!
      last_request.url.should == "http://example.org/add-translation/#{word.id}"
      last_response.should be_ok
    end

    it "should redirect to /add-word when given empty word" do
      post "/add-word", language: @english.id, word: ""
      follow_redirect!
      last_request.url.should == "http://example.org/add-word"
      last_response.should be_ok
    end

    it "should redirect to /add-word when given no word" do
      post "/add-word", language: @english.id
      follow_redirect!
      last_request.url.should == "http://example.org/add-word"
      last_response.should be_ok
    end

    it "should redirect to /add-word when given no language" do
      post "/add-word", word: "something"
      follow_redirect!
      last_request.url.should == "http://example.org/add-word"
      last_response.should be_ok
    end
  end

  describe "get /add-translation/:word_id" do
    it "should show word and form" do
      word = Word.first_or_create(name: "foobar", language: @english)
      get "/add-translation/#{word.id}"
      last_response.should be_ok
      last_response.should match /foobar/
      last_response.should match /<form/
    end
  end

  describe "post /add-translation/:word_id" do
    it "should add a new translation" do
      word = Word.first_or_create(name: "guitar", language: @english)
      post "/add-translation/#{word.id}", language: @polish.id, translation: "gitara"
      translation = Word.first(name: "gitara")
      translation.should_not be_nil
      word.translations.first.should == translation
    end
  end

  describe "post /add-language" do
    it "should redirect to address given in parameter" do
      post "/add-language", language: @english.id, redirect: "/foobar"
      follow_redirect!
      last_request.url.should == "http://example.org/foobar"
    end

    it "should redirect to / when given no redirect parameter" do
      post "/add-language", language: @english.id
      follow_redirect!
      last_request.url.should == "http://example.org/"
      last_response.should be_ok
    end
  end
end
