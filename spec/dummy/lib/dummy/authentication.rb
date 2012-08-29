module Dummy
  module Authentication
    
    extend ActiveSupport::Concern 
     
    included do
      helper_method :current_user, :logged_in?
      before_filter :store_location
    end
    
    private  
    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end
    def logged_in?
    	current_user
    end
    def require_user
      unless current_user
        redirect_to login_path, alert: "You need to log in to view this page."
        return false
      end
    end
    def store_location
      if request.get? and !request.xhr?
        session[:return_to] = request.url
      end
    end
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end
end

