class CommentsController < ApplicationController
	def create
		@comment = Comment.new ( comment_params )
		if @comment.valid?
			@comment.save
		end
		redirect_to "/wall/#{params[:current_wall]}"

	end

	private
	def comment_params
		params.permit(:comment, :user_id, :message_id, :authenticity_token, :current_wall)
	end
end
