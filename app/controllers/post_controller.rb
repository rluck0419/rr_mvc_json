class PostController < ApplicationController
  def show
    if post_exists?
      #iterate over each comment with the same post_id
      comments = []

      Comment.all.each do |c|
        if c.post_id == params[:id].to_i
          comments << Comment.all[c.id.to_i - 1]
        end
      end

      index = params[:id].to_i - 1
      
      post = {
        id: Post.all[index].id,
        title: Post.all[index].title,
        author: Post.all[index].author,
        body: Post.all[index].body,
        published: Post.all[index].published
      }

      post[:comments] = comments

      render post.to_json
    else
      render_not_found
    end
  end

  def index
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
