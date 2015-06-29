class WallController < ApplicationController
  def index
  end

  def show
  	@user = User.find(params[:id])
  	@messages = Message.where(to: params[:id]).joins("LEFT JOIN users on users.id = messages.user_id").select("messages.*, users.first_name, users.last_name").order(created_at: :desc)
	@comments = Comment.joins("LEFT JOIN users on users.id = comments.user_id").select('comments.*, users.first_name, users.last_name')
  end
end
