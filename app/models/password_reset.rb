class PasswordReset < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :user, :identifier, :password, :password_confirmation, :reset_token, :reset_sent_at
  
  validates_presence_of :identifier
  
  before_create :generate_token
  
  
  def match_identifier?
    guest = User.where(['username = :identifier OR email = :identifier', :identifier => identifier]).first      
    if guest.present?
      self.update_attributes(:user => guest)
    else
      false
    end
  end
  
  def udpate_user_password(attributes = {})
    if passwords_valid?(attributes[:password], attributes[:password_confirmation])
      user.password = attributes[:password]
      user.password_confirmation = attributes[:password_confirmation]
      user.save
    else
      false
    end
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.update_attributes(:reset_sent_at => Time.zone.now)
    save(:validate => false)
    PasswordResetMailer.password_reset(user).deliver
  end
  
  private
  def generate_token
    begin
      self.reset_token = SecureRandom.urlsafe_base64
    end while PasswordReset.exists?(reset_token => self.reset_token)
  end
  
  def expired?
    reset_sent_at < 2.hours.ago
  end
  
  def passwords_valid?(password, confirmation)
    password.present? && confirmation.present? && password == confirmation 
  end
  
end