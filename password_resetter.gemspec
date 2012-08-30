$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "password_resetter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "password_resetter"
  s.version     = PasswordResetter::VERSION
  s.authors     = ["Eli Fatsi"]
  s.email       = ["efatsi@comcast.net"]
  s.homepage    = "https://github.com/efatsi/password_resetter"
  s.summary     = "Allowing Users to reset their password through email"
  s.description = "Allowing Users to reset their password through email"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "bcrypt-ruby"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7'
  s.add_development_dependency 'bcrypt-ruby'

end
