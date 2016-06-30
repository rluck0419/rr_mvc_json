class PostController < ApplicationController
  def show
    if post_exists?
      render Post.all[post_id].to_json
    else
      render_not_found
    end
  end

  def index
    puts "hey"
    render Post.all.to_json
  end



  private

  def post_exists?
    (1..Post.all.count).include?(params[:id].to_i)
  end

  def post_id
    params[:id].to_i - 1
  end

  def render_not_found
    render({ msg: "404 - not found" }.to_json, status: "404 NOT FOUND")
  end
end
