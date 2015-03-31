class SessionsController < ApplicationController

  #create the session resource ie, let user log in
  def create
  	#redirect_to new_user_path
    #this references the funciton we made in user.rb
  	user = User.authenticate(params[:email], params[:password])
  	if user.nil?
  		 flash[:error] = "couldn't find a user with those credentials"
       #if there is an error, redirect back to login
       redirect_to "/sessions/index/"
  	else
  		sign_in user #helper function
  		#redirect_to dashboard
  		redirect_to "/users/dashboard/"
  	end
  end

  def destroy
  	sign_out #helper function 
  	redirect_to root_path
  end

end
