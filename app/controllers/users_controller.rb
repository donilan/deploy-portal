class UsersController < ApplicationController
  before_action :must_be_admin!, except: [:refresh_api_token, :myaccount, :update_password]
  before_action :set_user, only: [:destroy, :lock, :unlock, :reset_password]

  def refresh_api_token
    current_user.refresh_api_token
    redirect_to action: :myaccount
  end

  # admin only
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def lock
    @user.lock_access!(send_instructions: false)
    redirect_to users_url, notice: 'user was successfully locked.'
  end

  def unlock
    @user.unlock_access!
    redirect_to users_url, notice: 'user was successfully unlocked.'
  end

  def reset_password
    @user.send_reset_password_instructions
    redirect_to users_url, notice: 'reset email was successfully sent.'
  end

  def create
    @user = User.create(user_params.merge(password: SecureRandom.hex))
    if @user.valid?
      @user.send_reset_password_instructions
      redirect_to users_url, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update_password
    if params[:user][:password] != params[:user][:password_confirmation]
      flash[:alert] = 'Two password must be the same.'
      render :myaccount
    end
    if current_user.update(user_password_params)
      flash[:notice] = 'Password was successfully changed.'
      redirect_to action: :myaccount
    else
      render :myaccount
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  protected
  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:name, :email, :username, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
