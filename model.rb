# -*- encoding : utf-8 -*-

require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
DataMapper::Model.raise_on_save_failure = true


class Language
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  validates_presence_of :name
  validates_uniqueness_of :name

  has n, :words

  def self.add(language)
    Language.first_or_create(name: language)
  end
end


class Word
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :language

  belongs_to :language
  has n, :translation_pairs, :child_key => [ :first_id ]
  has n, :translations, self, :through => :translation_pairs, :via => :second

  def self.add(word, language)
    Word.first_or_create(name: word, language: Language.add(language))
  end
end


class TranslationPair
  include DataMapper::Resource

  belongs_to :first, 'Word', :key => true
  belongs_to :second, 'Word', :key => true

  def self.add(a, b)
    TranslationPair.create(first: a, second: b)
    TranslationPair.create(first: b, second: a)
  end
end


DataMapper.finalize
DataMapper.auto_upgrade!
