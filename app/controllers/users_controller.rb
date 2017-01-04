class UsersController < ApplicationController
  def refresh_api_token
    current_user.refresh_api_token
    redirect_to action: :show
  end

  def update
    if params[:user][:password] != params[:user][:password_confirmation]
      flash[:alert] = 'Two password must be the same.'
      return render :show
    end
    if current_user.update(user_password_params)
      flash[:notice] = 'Password was successfully changed.'
      redirect_to action: :show
    else
      render :show
    end
  end

  protected
  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
