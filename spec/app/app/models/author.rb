class Author < ApplicationRecord
  has_many :posts

  accepts_nested_attributes_for :posts
end
