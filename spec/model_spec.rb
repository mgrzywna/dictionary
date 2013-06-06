require 'spec_helper'

describe "Language" do
  it "should require a name" do
    Language.create(name: "English").should be_valid
    Language.new().should_not be_valid
  end

  it "should have unique name" do
    Language.create(name: "German").should be_valid
    Language.new(name: "German").should_not be_valid
  end

  it "shouldn't allow empty name" do
    Language.new(name: "").should_not be_valid
  end

  it "should return list of words in particular language" do
    language = Language.create(name: "foobar")
    words = %w(lorem ipsum dolor sit amet)

    words.each_with_index { |word, i| Word.create(id: i + 1, name: word, language: language) }

    language.words.count.should == words.count
    language.words.each { |word| word.name.should == words[word.id - 1] }
  end

  it "should return list of words in particular language (ver. 2)" do
    language = Language.create(name: "foobar")
    words = %w(lorem ipsum dolor sit amet)

    words.each { |word| Word.create(name: word, language: language) }
    words.should == language.words.map { |word| word.name }
  end
end

describe "Word" do
  before :each do
    @english = Language.first_or_create(name: "English")
    @polish = Language.first_or_create(name: "Polish")
  end

  it "should require a name and language" do
    Word.new(name: "ruby", language: @english).should be_valid
    Word.new(language: @english).should_not be_valid
    Word.new(name: "python").should_not be_valid
    Word.new().should_not be_valid
  end

  it "shouldn't be empty" do
    Word.new(name: "", language: @english).should_not be_valid
  end

  it "should be unique within the same language" do
    Word.create(name: "taxi", language: @english).should be_valid
    Word.new(name: "taxi", language: @english).should_not be_valid
  end

  it "should allow different words within the same language" do
    Word.create(name: "taxi", language: @english).should be_valid
    Word.create(name: "driver", language: @english).should be_valid
  end

  it "should allow the same word within different languages" do
    Word.create(name: "taxi", language: @english).should be_valid
    Word.create(name: "taxi", language: @polish).should be_valid
  end

  describe "#translations" do
    it "should return word's translations sorted by language" do
      foo = Language.create(name: "foo")
      bar = Language.create(name: "bar")
      qux = Language.create(name: "qux")

      word = Word.create(name: "word", language: foo)

      translations = [
        Word.create(name: "lorem", language: bar),
        Word.create(name: "ipsum", language: qux),
        Word.create(name: "dolor", language: bar)
      ]

      translations.each { |translation| word.add_translation(translation) }
      translations.sort! { |x, y| x.language <=> y.language }
      word.translations.should == translations
    end
  end

  describe "#add_translation" do
    it "should add new translation of the word" do
      water = Word.create(name: "water", language: @english)
      woda = Word.create(name: "woda", language: @polish)
      water.add_translation(woda)
      water.translations.count.should == 1
      water.translations[0].should == woda
    end
  end

  describe "#remove_translation" do
    it "should remove particular translation of the word"
  end
end

describe "TranslationPair" do
  before :each do
    @a = Language.first_or_create(name: "a")
    @b = Language.first_or_create(name: "b")
    @c = Language.first_or_create(name: "c")

    @foo = Word.first_or_create(id: 1, name: "foo", language: @a)
    @bar = Word.first_or_create(id: 2, name: "bar", language: @b)
    @qux = Word.first_or_create(id: 3, name: "qux", language: @c)
  end

  it "should have first_id less than second_id" do
    TranslationPair.new(first: @foo, second: @bar).should be_valid
    TranslationPair.new(first: @bar, second: @foo).should_not be_valid
  end

  it "should require both words" do
    TranslationPair.new(first: @foo, second: @bar).should be_valid
    TranslationPair.new(first: @foo).should_not be_valid
    TranslationPair.new(second: @bar).should_not be_valid
    TranslationPair.new().should_not be_valid
  end

  it "should be unique" do
    TranslationPair.create(first: @foo, second: @bar).should be_valid
    TranslationPair.new(first: @foo, second: @bar).should_not be_valid
  end

  it "shouldn't have two words in the same language" do
    a = Word.first_or_create(name: "a", language: @a)
    b = Word.first_or_create(name: "b", language: @a)

    TranslationPair.new(first: a, second: b).should_not be_valid
  end

  describe "::add" do
    it "should create new translation" do
      TranslationPair.all.count.should == 0
      tp = TranslationPair.add(@foo, @bar)
      TranslationPair.all.count.should == 1
      TranslationPair.all[0].should == tp
    end

    it "should return existing translation when it was previously added" do
      a = TranslationPair.create(first: @foo, second: @bar)
      b = TranslationPair.add(@foo, @bar)
      a.should == b
    end

    it "should swap values when necessary" do
      TranslationPair.add(@foo, @bar).should be_valid
      TranslationPair.add(@bar, @foo).should be_valid
    end

    it "should be symmetrical" do
      TranslationPair.add(@foo, @bar).should == TranslationPair.add(@bar, @foo)
    end
  end

  describe "::remove" do
    it "should remove translation"
    it "should be symmetrical"
  end
end
