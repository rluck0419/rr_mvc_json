class CommentController < ApplicationController
  def show
    if comment_exists?
      render Comment.all[params[:id].to_i].to_json
    else
      render_not_found
    end
  end

  def index
    render Comment.all.to_json
  end

  def create
    Comment.new(params["post_id"].to_i, params["author"], params["message"])

    redirect_to "/posts/#{params["post_id"]}"
  end


  private

  def comment_exists?
    (1..Comment.all.count).include?(params[:id].to_i)
  end

  def comment_id
    params[:id].to_i - 1
  end

  def render_not_found
    render({ msg: "404 - not found" }.to_json, status: "404 NOT FOUND")
  end
end
