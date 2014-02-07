## PasswordResetter

PasswordResetter is a simple gem used to give Users the ability to reset their password within your Rails application.

#### The gem assumes to following about your Rails application:

* There exists a User model with an `:email` attribute.
* The application stores a logged in User with `session[:user_id]`
* You already have the [BCrypt gem](https://github.com/codahale/bcrypt-ruby)

## Getting Started

Get it.

    gem 'password_resetter'

Install it.

    bundle install

Migrate it.

    rake password_resetter_engine:install:migrations
    rake db:migrate

If you haven't already, set your action mailer host in config/environments.
Simply place the following lines at the bottom of the necessary environment files

    # Action mailer for reset passwords
    config.action_mailer.default_url_options = { :host => "localhost:3000" }

Set up the email which users will be emailed from in an initializer

    # config/initializers/password_resetter.rb
    PasswordResetter.setup do |config|
      config.from_email = "password.recover@example.com"
    end

Lastly, throw the following link into the appropriate view file (i.e. views/sessions/new.html.erb)

    <%= link_to "Forgot Password?", new_password_reset_path %>

## Visual Customization

To match the style of your own app, every element of the html.erb files comes tagged with a css id.

### New Password Reset Page
#### The page a User is directed when they click on the "Forgot Password?" link

The entire form is wrapped with

    :class => "password-reset-request-field"

Email input field is tagged with

    :id => "password_reset_email"

Reset Password button:

    :class => "password-reset-button reset"

### Complete Password Reset Page
#### The page a User is directed when they follow the link emailed to them after initializing the reset process


The entire form is wrapped with

    :class => "password-reset-complete-field"

Password and Password Confirmation fields tagged respectively with:

    :id => "password_reset_password"
    :id => "password_reset_password_confirmation"

Update Password button:

    :class => "password-reset-button update"

For example, in `application.css.scss`


    #password_reset_email, #password_reset_password, #password_reset_password_confirmation {
      margin-bottom: 15px;
      margin-top: 5px;
      width: 285px;
    }

    .password-reset-button {
      background: image-url("my_button.png");
      height: 25px;
      width: 100px;
    }
