class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected
  def must_be_admin!
    unless current_user.admin?
      flash[:alert] = "You don't have permission to do this"
      return redirect_to(root_path)
    end
  end
end
