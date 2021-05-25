class AuthorsController < ApplicationController
  def create
    author = Author.new(create_author_params)

    if author.save
      render json: AuthorSerializer.new(author).serializable_hash
    else
      head 500
    end
  end

  def update
    author = Author.find(params[:id])

    if author.update(update_author_params)
      render json: AuthorSerializer.new(author).serializable_hash, status: :ok
    else
      head 500
    end
  end

  private

  def create_author_params
    params.from_jsonapi.require(:author).permit(
      :name, :scissors_id,
      posts_attributes: [:title, :body, :category_name], post_ids: [],
      scissors_attributes: [:sharp],
    )
  end

  def update_author_params
    params.from_jsonapi.require(:author).permit(
      :name, :scissors_id,
      posts_attributes: [:id, :title, :body, :category_name], post_ids: [],
      scissors_attributes: [:sharp],
    )
  end
end
