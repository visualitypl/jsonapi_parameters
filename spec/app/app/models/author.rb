class Author < ApplicationRecord
  has_many :posts
  has_one :scissors

  accepts_nested_attributes_for :posts
  accepts_nested_attributes_for :scissors
end
