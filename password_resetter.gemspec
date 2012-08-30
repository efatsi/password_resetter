$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "password_resetter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "password_resetter"
  s.version     = PasswordResetter::VERSION
  s.executables << 'execute_migrations'
  s.authors     = ["Eli Fatsi"]
  s.email       = ["efatsi@comcast.net"]
  s.homepage    = "http://efatsi.github.com"
  s.summary     = "This will work one day."
  s.description = "And it will be sweet"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7'
  s.add_development_dependency 'bcrypt-ruby'

end
