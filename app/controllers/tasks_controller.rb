class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :run]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  def run
    @job = @task.start_new_job(current_user)
    respond_to do |format|
      format.js
    end
  end

  def new
    @task = Task.new
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.create(task_params)

    respond_to do |format|
      if @task.valid?
        format.html { redirect_to tasks_url, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_url, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:user_id, :name, :desc, :script, :env_group_id, :timeout,
                                   :version, :author, :admin_only)
    end
end
