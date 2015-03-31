class Message < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  attr_accessor :authenticity_token

  validates :message, presence: true
  
end
