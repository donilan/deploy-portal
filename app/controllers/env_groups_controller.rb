class EnvGroupsController < ApplicationController
  before_action :must_be_admin!
  before_action :set_env_group, only: [:edit, :update, :destory]

  def index
    @env_groups = EnvGroup.all
  end

  def new
    @env_group = EnvGroup.new(envs: [ Env.new, Env.new, Env.new])
  end

  def create
    @env_group = EnvGroup.create(env_group_params)
    if @env_group
      flash[:success] = 'Created env group success.'
      redirect_to env_groups_path
    else
      render 'new'
    end
  end

  def update
    if @env_group.update_attributes(env_group_params)
      flash[:success] = 'updated env group success.'
      redirect_to env_groups_path
    else
      render 'edit'
    end
  end

  def destory
    @env_group.delete
    flash[:notice] = 'Deleted an Env group'
    redirect_to action: :index
  end

  protected
  def env_group_params
    params.require(:env_group).permit(:name, envs_attributes: [:id, :key, :value, :_destroy])
  end

  def set_env_group
    @env_group = EnvGroup.friendly.find(params[:id])
  end
end
