FactoryGirl.define do
  factory :env do
    sequence(:key) { |n| "KEY_#{n}" }
    value "test_value"
  end
end
