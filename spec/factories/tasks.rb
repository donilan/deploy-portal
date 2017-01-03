FactoryGirl.define do
  factory :task do
    user { |c| c.association(:user) }
    name "test-task"
    desc "task for testing"
    script %|#!/usr/bin/env
echo Whatever
echo Whatever
echo Whatever
|
    env_group { |c| c.association(:env_group) }
  end
end
