module PasswordResetter
  module Resettable
    belongs_to :user

    attr_accessible :user, :email, :password, :password_confirmation, :reset_token, :reset_sent_at

    validates_presence_of :email
  
    def match_email?
      guest = find_guest(email)
      if guest.present?
        self.update_attributes(:user => guest)
      else
        false
      end
    end
    
    def find_guest(email_string)
      User.where(['email = ?', email_string]).first
    end

    def send_password_reset
      generate_token
      self.update_attributes(:reset_sent_at => Time.zone.now)
      save
      PasswordResetMailer.password_reset(user, self).deliver
    end

    def update_user_password(password, confirmation)
      if passwords_valid?(password, confirmation)
        user.password = password
        user.password_confirmation = confirmation
        user.save
      else
        false
      end
    end

    def expired?
      reset_sent_at < 2.hours.ago
    end

    def delete_existing
      PasswordReset.all.each do |pr|
        pr.delete if (pr.user_id == user.id) && (pr != self)
      end
    end

    private
    def generate_token
      begin
        self.reset_token = SecureRandom.urlsafe_base64
      end  while PasswordReset.exists?(:reset_token => self.reset_token)
      self.save
    end

    def passwords_valid?(password, confirmation)
      password.present? && confirmation.present? && password == confirmation 
    end
  
  end
end