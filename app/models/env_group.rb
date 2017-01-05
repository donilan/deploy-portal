class EnvGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :name
  validates_format_of :name, with: /\A[a-z0-9\-_]+\Z/i
  validates :name, uniqueness: true
  has_many :envs
  has_many :tasks
  accepts_nested_attributes_for :envs, reject_if: lambda { |v| v[:key].blank? }, allow_destroy: true

  attr_accessor :import_log

  def to_h
    { name: name,
      envs: envs.map { |env|
        { key: env.key, value: env.value }
      }
    }
  end
end
