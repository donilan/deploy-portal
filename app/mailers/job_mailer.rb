class JobMailer < ApplicationMailer
  def fail_mail(job)
    @job = job
    mail(to: Setting.notifiers, subject: "#{Setting.site} - execute task #{job.task.name} with job id ##{job.id} fail")
  end

  def success_mail(job)
    @job = job
    mail(to: Setting.notifiers, subject: "#{Setting.site} - execute task #{job.task.name} with job id ##{job.id} success")
  end
end
