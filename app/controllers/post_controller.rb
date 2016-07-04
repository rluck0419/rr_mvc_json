class PostController < ApplicationController
  def show
    if post_exists?
      #iterate over each comment with the same post_id
      comments = []

#### move this into post.rb ############################
      Comment.all.each do |c|
        if c.post_id == params[:id].to_i
          comments << Comment.all[c.id.to_i - 1]
        end
      end

      index = params[:id].to_i - 1

      post = Post.all[index]

      post = post.to_hash
      post[:comments] = comments
########################################################

      render post.to_json
    else
      render_not_found
    end
  end

  def index
    limit_body
    posts = Post.all

    if params["page"]
      page = params["page"].to_i
      bottom = (1 + (10 * (page - 1))) - 1
      top = (page * 10) - 1
      posts = Post.all[bottom..top]
      # provide all this inside of a higher-level hash containing next url, previous url, and posts for current page
      # {next: "/posts?page=3", prev: "/posts?page=1", posts: [{}, {}, {}...]}
    end

    render posts.to_json
  end

  def index_published
    limit_body
    published = []
    posts = Post.all
    posts.each do |post|
      if post.published
        published << post
      end
    end
    render published.to_json
  end

  def index_unpublished
    limit_body
    published = []
    posts = Post.all
    posts.each do |post|
      unless post.published
        published << post
      end
    end
    render published.to_json
  end

  def limited_index
    limit_body
    render Post.all[0..9].to_json
  end

  def create
    if params["title"] == "" || params["body"] == ""
      render_not_saved
    else
      post = Post.new(params["author"], params["title"], params["body"])
      redirect_to "/posts/#{post.id}"
    end
  end

  def update
    if post_exists?
      post = Post.all[post_id]
      post.published = true
    end

    redirect_to "/posts/#{params[:id]}"
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

  def render_not_saved
    render({ msg: "406 - not acceptable. title and body are required." }.to_json, status: "406 NOT ACCEPTABLE")
  end

  def limit_body
    Post.all.each do |post|
      post.body = post.body[0..299]
    end
  end
end
