module Utilities
  def self.generate_dates
    today = Date.today
    start_of_week = today.at_beginning_of_week
    end_of_week = (today + 5.weeks).at_end_of_week

    dates_with_times = (start_of_week..end_of_week).flat_map do |date|
      format_date = date.strftime(DATE_FORMAT)
      if date.saturday? || date.sunday?
        (10..23).map do |hour|
        start_time = Time.new(date.year, date.month, date.day, hour)
        end_time = start_time + 1.hour
          { 
            date: format_date, 
            start_time: start_time.strftime("%H:%M"), 
            end_time: end_time.strftime("%H:%M")
          }
        end
      else
        (19..23).map do |hour|
          start_time = Time.new(date.year, date.month, date.day, hour)
          end_time = start_time + 1.hour
            { 
              date: format_date, 
              start_time: start_time.strftime("%H:%M"), 
              end_time: end_time.strftime("%H:%M")
            }
        end
      end
    end
    
    dates_with_times
  end

  def self.availabilities
    assignations = Assignation.all
    users = User.all

    availabilities = assignations.flat_map do |assignation|
      users.map do |user|
        { 
          user_id: user.id, 
          assignation_id: assignation.id
        }
      end
    end
    availabilities
  end

end
