class AuthorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  has_many :posts
end
