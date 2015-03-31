class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  attr_accessor :authenticity_token, :current_wall

  validates :comment, presence:true

end
