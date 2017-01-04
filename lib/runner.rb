class Runner
  include Singleton
  attr_accessor :current_build, :thread

  def run(job)
    raise Exception.new('One job at a time, please wait for other job finished') if running?
    @current_build = Build.new(job)
    Rails.logger.info "#{Time.now.to_s} | Starting new build #{@current_build.id}..."
    @current_build.run
    Rails.logger.info "#{Time.now.to_s} | Build #{@current_build.id} started."
    job.update_attributes(status: @current_build.state, started_at: Time.now)

    Thread.new {
      Rails.logger.info "Start a thread to abort process when timeout."
      begin
        while running?
          abort_if_timeout
          update_build
          sleep 5
        end
      rescue => e
        Rails.logger.error "build check fail, reason: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
      Rails.logger.info "Guard thread is finished without any errors."
    }
  end

  def running?
    @current_build
  end

  protected
  def abort_if_timeout
    if @current_build.running? && @current_build.running_too_long?
      @current_build.timeout_abort
    end
  end

  def update_build
    return unless @current_build.completed?
    Rails.logger.info "#{Time.now.to_s} | Completed build #{@current_build.id}, #{@current_build.state}."
    Job.find(@current_build.id).update_attributes(finished_at: Time.now, status: @current_build.state)
    @current_build = nil
  end

end
