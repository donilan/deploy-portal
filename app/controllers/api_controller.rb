class ApiController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :verify_token
  def verify_token
    u = User.find_by(api_token: params[:token])
    if u.nil? || !u.admin?
      raise ActionController::RoutingError.new('Forbidden')
    end
    @current_user = u
  end

  def current_user
    @current_user
  end
end
