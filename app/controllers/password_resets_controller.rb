class PasswordResetsController < ApplicationController
  
  def new
    @password_reset = PasswordReset.new
  end                              
                                   
  def create                       
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.save
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      render :new
    end
  end

  def edit
    assign_password_reset
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    end
  end

  def update
    assign_password_reset
    if @password_reset.update_attributes(params[:password_reset])
      cookies[:auth_token] = @password_reset.existing_user.auth_token
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      render :edit
    end
  end
  
  def password_reset
    @password_reset
  end

  private
  def assign_password_reset
    @password_reset = PasswordReset.find(params[:id])
  end
  
end
