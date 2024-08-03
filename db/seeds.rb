users_attributes = [
  { name: 'Ernesto' },
  { name: 'Bárbara' },
  { name: 'Benjamín' },
]

users_attributes.each do |attributes|
  User.where(name: attributes[:name]).first_or_create!
end

date = Utilities.generate_dates
date.each do |attributes|
  Assignation.where(date: attributes[:date], start_time: attributes[:start_time], end_time: attributes[:end_time])
    .first_or_create!(date: attributes[:date], start_time: attributes[:start_time], end_time: attributes[:end_time], user_id: nil)
end

availability = Utilities.availabilities
availability.each do |attributes|
    Availability.where(user_id: attributes[:user], assignation_id: attributes[:assignation])
    .first_or_create!(attributes)
end