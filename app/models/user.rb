class User < ApplicationRecord
  has_many :assignations
  has_many :availabilities
end
