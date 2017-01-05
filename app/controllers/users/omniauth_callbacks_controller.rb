class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :initialize_omniauth_state

  def gitlab
    @user = User.from_omniauth(request.env["omniauth.auth"])
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Gitlab"
    sign_in_and_redirect @user, :event => :authentication
  end

  protected

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end
end
