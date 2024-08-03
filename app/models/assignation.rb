class Assignation < ApplicationRecord
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  has_many :availabilities
  belongs_to :user, optional: true
end
