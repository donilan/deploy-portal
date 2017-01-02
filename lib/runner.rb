class Runner
  attr_accessor :current_build, :thread

  def self.current
    @@runnder ||= Runner.new
  end

  def initialize
    Thread.new {
      begin
        loop do
          if running?
            abort_if_timeout
            update_build
          end
          sleep 5
        end
      rescue => e
        Rails.logger.error "build check fail, reason: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    }
  end

  def run(job)
    # TODO do something if current build is running
    return if running?
    @current_build = Build.new(job)
    Rails.logger.info "#{Time.now.to_s} | Starting new build #{@current_build.id}..."
    @current_build.run
    Rails.logger.info "#{Time.now.to_s} | Build #{@current_build.id} started."
    job.update_attributes(status: @current_build.state, started_at: Time.now)
  end

  protected

  def running?
    @current_build
  end

  def abort_if_timeout
    if @current_build.running? && @current_build.running_too_long?
      @current_build.timeout_abort
    end
  end

  def update_build
    return unless @current_build.completed?
    Rails.logger.info "#{Time.now.to_s} | Completed build #{@current_build.id}, #{@current_build.state}."
    Job.find(@current_build.id).update_attributes(trace: collect_trace, finished_at: Time.now, status: @current_build.state)
    @current_build.cleanup
    @current_build = nil
  end

  def network
    @network ||= Network.new
  end

  def collect_trace
    @current_build.trace
  end
end
