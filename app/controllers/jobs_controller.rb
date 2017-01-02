class JobsController < ApplicationController
  before_action :set_task
  before_action :set_job, only: [:show, :trace]

  def index
    @jobs = @task.jobs
  end

  def trace
    respond_to do |format|
      format.json do
        state = params[:state].presence
        render json: @job.trace_with_state(state).merge!(id: @job.id, status: @job.status)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = @task.jobs.find(params[:id])
    end

    def set_task
      @task = Task.find(params[:task_id])
    end
end
