class PasswordResetsController < ApplicationController
  
  before_filter :assign_password_reset, :only => [:edit, :update]
  
  def new
    @password_reset = PasswordReset.new
  end                              
                                   
  def create                       
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.match_identifier? && @password_reset.save
      @password_reset.send_password_reset ### PROBLEM IS RIGHT HERE!!
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      redirect_to new_password_reset_path, :alert => "Could not find a user to match :("
    end
  end

  def edit
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    end
  end

  def update
    if @password_reset.update_user_password(params[:password_reset][:password], params[:password_reset][:password_confirmation])
      session[:user_id] = @password_reset.user.id
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      render :edit
    end
  end

  private
  def assign_password_reset
    @password_reset = PasswordReset.find_by_reset_token(params[:id])
  end
  
end
