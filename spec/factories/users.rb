FactoryGirl.define do 
  factory :user do
    sequence(:username) {|n|"user_#{n}" }
    password 'password'
    password_confirmation 'password'
  end
end