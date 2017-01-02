module ApplicationHelper

  def job_status(job)
    return '-' if job.nil?
    case job.status
    when 'success'
      content_tag :span, class: 'label label-success' do
        'Success'
      end
    when 'failed'
      content_tag :span, class: 'label label-danger' do
        'Failed'
      end
    when 'running'
      content_tag :span, class: 'label label-warning' do
        'Running'
      end
    end
  end
end
