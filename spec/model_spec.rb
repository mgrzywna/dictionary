require 'spec_helper'

describe 'Language' do
  it 'is valid with valid attributes' do
    Language.destroy
    @language = Language.new name: 'English'
    @language.should be_valid
  end

  it 'is not valid without a name' do
    Language.destroy
    @language = Language.new name: nil
    @language.name = nil
    @language.should_not be_valid
  end

  it 'is not valid when name is not unique ' do
    Language.destroy
    en = Language.new name: 'English'
    en.save
    en.should be_valid
    en = Language.new name: 'English'
    en.should_not be_valid
  end
end
