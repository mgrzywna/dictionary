require 'spec_helper'

describe 'Language' do
  before :each do
    @language = Language.new(name: 'English')
  end

  it 'is valid with valid attributes' do
    @language.should be_valid
  end

  it 'is not valid without a name' do
    @language.name = nil
    @language.should_not be_valid
  end

  it 'is unique' do
    en = Language.new(name: 'English')
    en.save
    en.should be_valid
    en = Language.new(name: 'English')
    en.should_not be_valid
  end
end
