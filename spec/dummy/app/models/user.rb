class User < ActiveRecord::Base
  
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
  
end
