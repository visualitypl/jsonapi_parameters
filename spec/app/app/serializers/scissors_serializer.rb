class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :sharp

  belongs_to :author
end
