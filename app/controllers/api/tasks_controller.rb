class Api::TasksController < ApiController
  def run
    @task = Task.friendly.find(params[:id])
    if @task.nil?
      return render_404
    end
    render body: `#{@task.script_path}`
    rescue => e
      render body: e.message
  end
end
