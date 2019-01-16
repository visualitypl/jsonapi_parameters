class Post < ApplicationRecord
  belongs_to :author

  accepts_nested_attributes_for :author
end
