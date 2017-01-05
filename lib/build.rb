require 'childprocess'
require 'tempfile'

require 'bundler'
require 'shellwords'

class Build

  attr_accessor :id
  attr_reader :job
  delegate :task, to: :job

  def initialize(job)
    @job = job
    @id = @job.id
    @timeout = task.timeout
    @run_at = Time.now
  end

  def run
    Bundler.with_clean_env { execute("setsid #{task.script_path}") }
  end

  def state
    return :success if success?
    return :failed if failed?
    :running
  end

  def completed?
    @process.exited?
  end

  def success?
    return nil unless completed?
    @process.exit_code == 0
  end

  def failed?
    return nil unless completed?
    @process.exit_code != 0
  end

  def running?
    @process.alive?
  end

  def abort
    @process.stop
  end

  # Check if build execution is longer
  # than allowed by timeout
  def running_too_long?
    if @run_at && @timeout
      @run_at + @timeout < Time.now
    else
      false
    end
  end

  def timeout_abort
    self.abort
    @log_file.puts "\nTimeout. Execution took longer then #{@timeout} seconds"
  end

  private

  def execute(cmd)
    cmd = cmd.strip
    Rails.logger.info "going to execute command #{cmd}"
    @process = ChildProcess.build('bash', '--login', '-c', cmd)
    @log_file = File.new(@job.log_path, 'w+', binmode: true)
    @process.io.stdout = @log_file
    @process.io.stderr = @log_file
    @process.cwd = task.cwd if task.cwd

    # TODO: need a better way to set envs
    task.env_group && task.env_group.envs.each do |env|
      @process.environment[env.key] = env.value
    end
    @process.start
  rescue => e
    Rails.logger.error "excute fail, reason: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @log_file.puts e.message
  end

end
