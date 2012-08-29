class PasswordReset < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :existing_user, :user

  validates_presence_of :identifier, :unless => :persisted? 
  validates_presence_of :password, :if => :persisted?
  validates_confirmation_of :password, :if => :password?
  validate :user_exists, :unless => :persisted?
  validate :user_has_email_address, :unless => :persisted?

  def self.find(id)
    new(:existing_user => User.find_by_password_reset_token(id))
  end

  def update_attributes(attributes = {})
    self.attributes = attributes
    if valid?
      existing_user.password = attributes[:password]
      existing_user.password_confirmation = attributes[:password_confirmation]
      existing_user.password_reset_token = nil
      existing_user.save
    else
      false
    end
  end

  def user
    @user ||= if identifier.present?
      User.where(['username = :identifier OR email = :identifier', :identifier => identifier]).first
    end
  end

  # def id
  #   existing_user.try(:password_reset_token)
  # end

  def expired?
    existing_user.password_reset_sent_at < 2.hours.ago
  end

  def persisted?
    id.present?
  end

  private

  def user_exists
    errors.add(:user, "was not found") unless user
  end

  def user_has_email_address
    errors.add(:user, "must have an email address") if user && user.email.blank?
  end

  def password?
    password.present?
  end

  def attributes=(attributes)
    (attributes || {}).each {|k,v| send("#{k}=", v) }
  end

end