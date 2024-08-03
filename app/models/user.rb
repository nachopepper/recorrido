class User < ApplicationRecord
  validates :name, presence: true
  has_many :assignations
  has_many :availabilities
end
