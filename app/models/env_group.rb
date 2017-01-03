class EnvGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :name
  validates_format_of :name, with: /\A[a-z0-9\-_]+\Z/i
  validates :name, uniqueness: true
  has_many :envs
  has_many :tasks
end
