FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user#{n}@example.com" }
    confirmed_at Time.zone.now
    password '123456'
    password_confirmation '123456'
  end
end
