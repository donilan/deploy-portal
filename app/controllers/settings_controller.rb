class SettingsController < ApplicationController
  before_action :get_setting, only: [:edit, :update]
  before_action :must_be_admin!

  def index
    @settings = Setting.get_all
  end

  def update
    if @setting.value != params[:setting][:value]
      @setting.value = params[:setting][:value]
      @setting.save
      redirect_to settings_path, notice: 'Setting has updated.'
    else
      redirect_to settings_path
    end
  end

  protected
  def get_setting
    @setting = Setting.find_by(var: params[:id]) || Setting.new(var: params[:id])
  end
end
