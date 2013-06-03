require 'spec_helper'

describe 'Language' do
  it 'should require a name' do
    Language.create(name: 'English').should be_valid
    Language.new().should_not be_valid
  end

  it 'should have unique name' do
    Language.create(name: 'German').should be_valid
    Language.new(name: 'German').should_not be_valid
  end
end

describe 'Word' do
  before :each do
    @english = Language.first_or_create(name: 'English')
    @german = Language.first_or_create(name: 'German')
  end

  it 'should require a name and language' do
    Word.new(name: 'ruby', language: @english).should be_valid
    Word.new(language: @english).should_not be_valid
    Word.new(name: 'python').should_not be_valid
  end

  it 'should have unique name within scope of one language' do
    Word.create(name: 'taxi', language: @english).should be_valid
    Word.new(name: 'taxi', language: @english).should_not be_valid
    Word.new(name: 'taxi', language: @german).should be_valid
  end
end

describe 'TranslationPair' do
  before do
    english = Language.first_or_create(name: 'English')
    @foo = Word.first_or_create(name: 'foo', language: english)
    @bar = Word.first_or_create(name: 'bar', language: english)
  end

  it 'should require both words' do
    TranslationPair.new(first: @foo, second: @bar).should be_valid
    TranslationPair.new(first: @foo).should_not be_valid
    TranslationPair.new(second: @bar).should_not be_valid
  end

  it 'should be unique' do
    TranslationPair.create(first: @foo, second: @bar).should be_valid
    TranslationPair.new(first: @foo, second: @bar).should_not be_valid
  end
end
