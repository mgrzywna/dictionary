# -*- encoding : utf-8 -*-

require 'data_mapper'

configure :production do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")
  DataMapper::Model.raise_on_save_failure = false
end

configure :test do
  DataMapper.setup(:default, 'sqlite::memory:')
  DataMapper::Model.raise_on_save_failure = true
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper::Model.raise_on_save_failure = true
end

class Language
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  validates_presence_of :name
  validates_uniqueness_of :name
  has n, :words
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
end

class TranslationPair
  include DataMapper::Resource
  belongs_to :first, 'Word', :key => true
  belongs_to :second, 'Word', :key => true
end

DataMapper.finalize
DataMapper.auto_upgrade!
