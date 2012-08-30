class PasswordResetsController < ApplicationController
  
  
  def new
    @password_reset = PasswordReset.new
  end                              
                                   
  def create                       
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.match_identifier? && @password_reset.save
      @password_reset.delete_existing
      @password_reset.send_password_reset
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      redirect_to new_password_reset_path, :alert => "Could not find a user to match :("
    end
  end

  def edit
    @password_reset = PasswordReset.find_by_reset_token(params[:id])
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    end
  end

  def update
    @password_reset = PasswordReset.find(params[:id])
    if @password_reset.update_user_password(params[:password_reset][:password], params[:password_reset][:password_confirmation])
      session[:user_id] = @password_reset.user.id
      @password_reset.destroy
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      render :edit
    end
  end
  
end
