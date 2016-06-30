require 'faker'
class Post
  @@all = []
  attr_reader :id
  attr_accessor :title, :author, :body, :published

  def initialize(author, title, body, published)
    @@all << self
    @id = set_id
    @title = title
    @author = author
    @body = body
    @published = published
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
    @@all
  end

  private

  def set_id
    $__post_id ||= 0
    $__post_id += 1
  end
end
