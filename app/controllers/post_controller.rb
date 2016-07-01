class PostController < ApplicationController
  def show
    if post_exists?
      #iterate over each comment with the same post_id
      comments = []

### "put" this into post.rb ############################
      Comment.all.each do |c|
        if c.post_id == params[:id].to_i
          comments << Comment.all[c.id.to_i - 1]
        end
      end

      index = params[:id].to_i - 1

      post = Post.all[index]

      post = post.to_hash
      post[:comments] = comments
#######################################################

      render post.to_json
    else
      render_not_found
    end
  end

  def index
    Post.all.each do |post|
      post.body = post.body[0..299]
    end
    render Post.all.to_json
  end

  def create
    post = Post.new(params["author"], params["title"], params["body"])

    redirect_to "/posts/#{post.id}"
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
