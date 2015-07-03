class UsersController < ApplicationController

  def index
    #if already signed in send to dashboard
    if signed_in? && !is_admin?
      redirect_to '/users/dashboard'
    end
  end

  def landing
    if signed_in?
      redirect_to '/users/dashboard'
    end
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
    collection = User.count
    #only allow first user to be admin
    if collection == 0 
      params[:user_level] = 9
    else
      params[:user_level] = 1
    end

  	@user = User.new ( user_params )
    if @user.save && is_admin?
    	flash[:notice] = 'New user created.'
      #shouldn't this be set when you sign on, Not when you create an account?
      #if !signed_in?
        #sets user info
       # sign_in @user
      #end
    elsif @user.save
      flash[:notice] = 'New user created. Please log in.'
    else     
    	 flash[:errors] = @user.errors.full_messages
    end

    #send back to page telling them success or rail
    redirect_to '/users'

    #is log in failed send them to users
    # if !signed_in?
    #   redirect_to '/users/'
    #   return
    # elsif signed_in? && is_admin?
    #   redirect_to '/users/new/'
    #   return
    # else
    #   deny_access
    #   return
    # end
  end

  def edit
    if !signed_in?
      deny_access
    end

    # if a user tried to access another persons 
    # account and is NOT an admin redirect to dashboard  
    if !is_admin? && params[:id].to_s != current_user.id.to_s
      redirect_to "/users/dashboard"
    else 
      @user = User.find( params[:id] )
    end    
  end

  # def edit_profile
  #   if !signed_in?
  #     deny_access
  #   end

  #   puts 'helloooooo'
  #   puts session[:user_id]

  #   redirect_to "/users/#{session[:user_id]}/edit_own"
  # end

  # def edit_own
  #   if !signed_in?
  #     deny_access
  #   end
  #   #only own user can access own page
  #   if current_user.id.to_s == params[:id].to_s
  #     @user = User.find( params[:id] )
  #   else
  #     redirect_to "/users/dashboard"
  #   end
  # end

  def update
    #applied to both info and password

    if !signed_in?
      deny_access
    end

    if !is_admin? && params[:id].to_s != current_user.id.to_s
      redirect_to "/users/dashboard"
    end
    

    #User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name])

    @user = User.find( params[:id] )
    if params[:form] == "gen_info"
      #puts "in the general info lksdjflkdsjlfkjsdlkfjdlsk"
      if is_admin? && params[:id].to_i != @current_user.id.to_i
        if User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], user_level: params[:user_level], description: params[:description])
          flash[:general] = "Info Updated"
        else 
          flash[:general] = "Errors updating. Make sure all fields filled"
        end
      else
        if User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], description: params[:description] )
          flash[:general] = "Info Updated"
        else
          flash[:general] = "Errors updating. Make sure all fields filled"      
        end
      end
    end

    if params[:form] == "pass"
      if params[:password] != params[:confirm] || params[:password].length < 8 
        flash[:password_mess] = 'Passwords must match and be a min of 8 characters! Please re-enter'
      elsif User.find(params[:id]).update(password: params[:password])
        #@user.find(params[:id]).update(password: params[:password])
        flash[:password_mess] = 'Password updated!'
      else 
        flash[:password_mess] = "Password cannot be blank and min of 8 characters"
      end
    end
    redirect_to edit_user_path
  end

    #if not an admin they can update / change password / or add a description
    # if params[:admin_edit] == 'true'
    #   User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], user_level: params[:user_level])  
    # elsif params[:admin_pass] == 'true'
    #   if params[:password] != params[:confirm] 
    #     flash[:password_mess] = 'Passwords must match! Please re-enter'
    #   else 
    #   User.find(params[:id]).update(password: params[:password])
    #   flash[:password_mess] = 'Password updated!'
    #   end
    # end

    # if params[:admin_edit] || params[:admin_pass]
    #   redirect_to "/users/#{params[:id]}/edit"
    #   return
    # end

    # if params[:self_edit] == 'true'
    #   User.find(params[:id]).update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name])  
    # elsif params[:self_password] == 'true'
    #   User.find(params[:id]).update(password: params[:password])
    # elsif params[:self_description] == 'true'
    #   User.find(params[:id]).update(description: params[:description])
    # end

    # if params[:self_edit] || params[:self_password] || params[:self_description]
    #   redirect_to "/users/#{params[:id]}/edit_own"
    #   return
    # end


  def destroy
    #only admins can remove users
    if !signed_in? && !is_admin
      redirect_to users_dashboard_path
    end

    User.find(params[:id]).destroy
    redirect_to users_dashboard_path
  end

  #define strong parameters!
  private
    def user_params
      params.permit(:first_name, :last_name, :email, :password, :user_level, :password_confirmation, :description, :authenticity_token)
    end

end
