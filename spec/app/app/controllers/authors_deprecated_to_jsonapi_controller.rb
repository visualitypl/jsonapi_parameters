class AuthorsDeprecatedToJsonapiController < ApplicationController
  def create
    author = Author.new(author_params)

    if author.save
      render json: AuthorSerializer.new(author).serializable_hash
    else
      head 500
    end
  end

  private

  def author_params
    params.to_jsonapi.require(:author).permit(
      :name, posts_attributes: [:title, :body, :category_name]
    )
  end
end
