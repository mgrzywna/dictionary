require 'spec_helper'

describe 'Language' do
  before do
    Language.destroy
  end

  it 'is valid with valid attributes' do
    language = Language.new name: 'English'
    language.should be_valid
  end

  it 'is not valid without a name' do
    language = Language.new
    language.name = nil
    language.should_not be_valid
  end

  it 'is not valid when name is not unique ' do
    en = Language.new name: 'English'
    en.save
    en.should be_valid
    en = Language.new name: 'English'
    en.should_not be_valid
  end
end

describe 'Word' do
  before do
    @lang = Language.first_or_create name: 'English'
    Word.destroy
  end

  it 'is valid with valid attributes' do
    word = Word.new name: 'ruby', language: @lang
    word.should be_valid
  end

  it 'is not valid without a name' do
    word = Word.new language: @lang
    word.should_not be_valid
  end

  it 'is not valid without a language' do
    word = Word.new name: 'python'
    word.should_not be_valid
  end

  it 'is not valid when name is not unique within scope of one language' do
    word = Word.new name: 'awesome', language: @lang
    word.save
    word.should be_valid
    word = Word.new name: 'awesome', language: @lang
    word.should_not be_valid
  end
end

describe 'TranslationPair' do
  before do
    lang = Language.first_or_create name: 'English'
    @word_a = Word.first_or_create name: 'a', language: lang
    @word_b = Word.first_or_create name: 'b', language: lang
    TranslationPair.destroy
  end

  it 'is valid with valid attributes' do
    tp = TranslationPair.new first: @word_a, second: @word_b
    tp.should be_valid
  end

  it 'is not valid without first word' do
    tp = TranslationPair.new second: @word_b
    tp.should_not be_valid
  end

  it 'is not valid without second word' do
    tp = TranslationPair.new first: @word_a
    tp.should_not be_valid
  end

  it 'is not valid when pair is not unique' do
    tp = TranslationPair.new first: @word_a, second: @word_b
    tp.save
    tp.should be_valid
    tp = TranslationPair.new first: @word_a, second: @word_b
    tp.should_not be_valid
  end
end
