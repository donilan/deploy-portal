class Job < ApplicationRecord
  belongs_to :user
  belongs_to :task
  default_scope { order('updated_at DESC')}

  def trace_with_state(state)
    Ansi2html.convert(File.read(log_path), state)
  end

  def log_folder_path
    @_log_folder_path ||= Rails.root.join('task_log', task.id.to_s)
  end

  def log_path
    FileUtils.mkdir_p log_folder_path unless File.exist?(log_folder_path)
    Rails.root.join(log_folder_path, id.to_s).to_s
  end

end
