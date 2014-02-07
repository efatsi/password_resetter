class PasswordResetMailer < ActionMailer::Base
  default from: PasswordResetter.from_email

  def password_reset(user, password_reset)
    @user = user
    @token = password_reset.reset_token
    mail :to => user.email, :subject => "Password Reset"
  end
end
