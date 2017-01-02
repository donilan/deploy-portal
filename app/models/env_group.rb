class EnvGroup < ApplicationRecord
  has_many :envs
  has_many :tasks
end
