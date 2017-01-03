class Env < ApplicationRecord
  belongs_to :enviroment_group
  validates_format_of :key, with: /\A[a-z0-9\-_]+\Z/i
  validates :key, uniqueness: true
end
