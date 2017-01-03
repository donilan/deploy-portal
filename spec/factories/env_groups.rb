FactoryGirl.define do
  factory :env_group do
    name "test-env-group"
    envs { |e| [ e.association(:env), e.association(:env)] }
  end
end
