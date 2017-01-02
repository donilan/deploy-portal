class Job < ApplicationRecord
  belongs_to :user
  belongs_to :task
  default_scope { order('updated_at DESC')}

  def trace_with_state(state)
    Ansi2html.convert(File.read(Rails.root.join('task_log', task.id.to_s, id.to_s)), state)
  end
end
