require 'faker'
class Comment
  @@all = []
  attr_reader :id, :post_id
  attr_accessor :message, :author

  def initialize(post_id, author, message)
    @@all << self
    @id = set_id
    @post_id = post_id
    @author = author
    @message = message
  end

  def to_json(json_arg = nil)
    {
      id: @id,
      message: @message,
      author: @author,
      post_id: @post_id
    }.to_json
  end

  def self.all
    @@all
  end

  def set_id
    $__comment_id ||= 0
    $__comment_id += 1
  end
end
