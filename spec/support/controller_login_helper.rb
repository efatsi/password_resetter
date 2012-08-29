module ControllerLoginHelper
  def login_as(user)
    controller.stub(:current_user).and_return(user)
  end
end