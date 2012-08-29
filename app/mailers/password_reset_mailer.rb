class PasswordResetMailer < ActionMailer::Base
  default from: "haxxor_news@example.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
