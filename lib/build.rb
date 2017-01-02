require 'childprocess'
require 'tempfile'

require 'bundler'
require 'shellwords'

class Build

  attr_accessor :id, :output, :post_message
  attr_reader :job
  delegate :task, to: :job

  def initialize(job)
    @job = job
    @id = @job.id
    @output = ""
    @post_message = ""
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

  def trace
    output + build_log + post_message
  rescue
    ''
  end

  def build_log
    build_log = OutputEncode.encode!(File.binread(output_file_path)) if output_file_path && File.readable?(output_file_path)
    build_log ||= ''
  end

  def cleanup
    # Not implement yet
    # @tmp_file.rewind
    # @tmp_file.close
    # @tmp_file.unlink
    # @run_file.unlink
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

    @post_message = "\nTimeout. Execution took longer then #{@timeout} seconds"
  end

  def output_file_path
    output_folder = Rails.root.join('task_log', task.id.to_s).to_s
    FileUtils.mkdir_p output_folder unless File.exist?(output_folder)
    Rails.root.join('task_log', task.id.to_s, id.to_s).to_s
  end

  private

  def execute(cmd)
    cmd = cmd.strip
    Rails.logger.info "going to execute command #{cmd}"
    @process = ChildProcess.build('bash', '--login', '-c', cmd)
    @log_file = File.new(output_file_path, 'w+', binmode: true)
    @process.io.stdout = @log_file
    @process.io.stderr = @log_file
    # @process.cwd = project_dir

    task.env_group.envs.each do |env|
      @process.environment[env.key] = env.value
    end
    @process.start
  rescue => e
    Rails.logger.error "excute fail, reason: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @output << e.message
  end

end
