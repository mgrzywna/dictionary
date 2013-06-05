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
end

describe "Word" do
  before :each do
    @english = Language.first_or_create(name: "English")
    @german = Language.first_or_create(name: "German")
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
    Word.create(name: "taxi", language: @german).should be_valid
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

  describe "add method" do
    it "should swap values when necessary" do
      TranslationPair.add(@foo, @bar).should be_valid
      TranslationPair.add(@bar, @foo).should be_valid
    end

    it "should be symmetrical" do
      TranslationPair.add(@foo, @bar).should == TranslationPair.add(@bar, @foo)
    end
  end
end
