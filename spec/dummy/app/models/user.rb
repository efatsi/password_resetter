class User < ActiveRecord::Base

  before_create { generate_token(:auth_token) }
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :password_reset_sent_at
  
	def self.authenticate(username, password)
		find_by_username(username).try(:authenticate, password)
	end
	
  def attempt_password_change(params)
    if User.authenticate(self.username, params[:password][:old_password]) == self 
      
      self.password = params[:password][:new_password] 
      self.password_confirmation = params[:password][:new_password_confirmation] 
      if password == ""
        :blank
      elsif self.save  
        :success
      elsif password != password_confirmation
        :mismatch
      else 
        :failed
      end 
    else 
      :old_password_incorrect 
    end  
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save(:validate => false)
    PasswordResetMailer.password_reset(self).deliver
  end
  
end
