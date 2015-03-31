class MessagesController < ApplicationController
	def create
		puts 'hello world!'
		@message = Message.new ( message_params )

		if !@message.save
  			flash[:error] = 'Message cannot be blank!'
  		else 
  			@message.save
  		end

		redirect_to	"/wall/#{params[:user_id]}"	
	end

  private
    def message_params
    	params.permit(:message, :user_id, :to, :authenticity_token)
    end

end
