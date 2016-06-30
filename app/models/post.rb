require 'faker'
class Post
  @@all = []
  attr_reader :id
  attr_accessor :title, :author, :body, :published

  def initialize(title, author, body, published)
    @title = title
    @author = author
    @body = body
    @published = published
    @id = set_id
  end

  def to_json(json_arg = nil)
    {
      id: @id,
      title: @title,
      author: @author,
      body: @body,
      published: @published
    }.to_json
  end

  def self.all
    @all
  end

  private
  
  def set_id
    $__user_id ||= 0
    $__user_id += 1
  end
end
