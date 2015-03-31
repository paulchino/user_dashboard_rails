class UsersController < ApplicationController

  def index
  end

  def dashboard
    if !signed_in?
      deny_access
    end
    @users = User.all;
  end

  def new
    if !signed_in? || !is_admin?
      deny_access
    end


  end

  def create
    #this handles both the register and add a new user

  	puts 'controller!!!'
  	@user = User.new ( user_params )

    if @user.save
    	flash[:notice] = 'New user created. Please Log In!'
      if !signed_in?
        sign_in @user
      end

    else
    	flash[:errors] = @user.errors.full_messages
    end

    if !signed_in?
      redirect_to '/users/'
      return
    elsif signed_in? && is_admin?
      redirect_to '/users/new/'
      return
    else
      deny_access
      return
    end
  end

  def edit
    #only admins have access to this page
    if !signed_in? || !is_admin?
      deny_access
    end
    @user = User.find( params[:id] )
  end

  def edit_profile
    if !signed_in?
      deny_access
    end

 
    puts 'helloooooo'
    puts session[:user_id]

    redirect_to "/users/#{session[:user_id]}/edit_own"
  end

  def edit_own
   # @user = current_user
   #  if !current_user?( @user )
   #    deny_access
   #  end
    @user = User.find( params[:id] )
  end

  def update
    #if not an admin they can update / change password / or add a description
    if params[:admin_edit] == 'true'
      User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], user_level: params[:user_level])  
    elsif params[:admin_pass] == 'true'
      if params[:password] != params[:confirm] 
        flash[:password_mess] = 'Passwords must match! Please re-enter'
      else 
      User.find(params[:id]).update(password: params[:password])
      flash[:password_mess] = 'Password updated!'
      end
    end

    if params[:admin_edit] || params[:admin_pass]
      redirect_to "/users/#{params[:id]}/edit"
      return
    end

    if params[:self_edit] == 'true'
      User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name])  
    elsif params[:self_password] == 'true'
      User.find(params[:id]).update(password: params[:password])
    elsif params[:self_description] == 'true'
      User.find(params[:id]).update(description: params[:description])
    end

    if params[:self_edit] || params[:self_password] || params[:self_description]
      redirect_to "/users/#{params[:id]}/edit_own"
      return
    end
  end

  def destroy
    puts params[:id]
    User.find(params[:id]).destroy
    redirect_to users_dashboard_path
  end

  #define strong parameters!
  private
    def user_params
      params.permit(:first_name, :last_name, :email, :password, :user_level, :password_confirmation, :authenticity_token)
    end

end
