FactoryGirl.define do
  factory :job do
    task_id 1
    status "MyString"
    finished_at "2017-01-02 00:00:34"
    trace "MyText"
    started_at "2017-01-02 00:00:34"
    user_id 1
  end
end
