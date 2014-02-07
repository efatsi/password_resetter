require "password_resetter/engine"

module PasswordResetter
  mattr_accessor :from_email
  @@from_email = "password.resetter@no-reply.com"

  def self.setup
    yield self
  end
end
