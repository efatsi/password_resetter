module AccountHelper
  
  def login_with(username, password)
    visit '/login' if current_path != '/login'
    fill_in 'Username', :with => username
    fill_in 'Password', :with => password
    click_button 'Log In'
  end
  
end