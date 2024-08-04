class GreedyService
  # Asigno inmediatamente para los días que solo un usuario eligió
  def assign_exclusive_day(availability, hours_per_user)
    hours_per_user = hours_per_user
    hours_assigned_per_user = {}
    exclude_dates = []

    availability.each do |date, days|
      user_available = nil
      assignation = []

      days.each do |assignation_id, hours|
        if user_available == -1
          assignation.clear
          next
        end

        # Encuentra todos los usuarios con todas las horas habilitadas
        all_true_users = hours.select { |_, enabled| enabled }.keys

          if all_true_users.size > 1
            user_available = -1
            next
          end

          if all_true_users.any?
            current_user = all_true_users.first

            if user_available.nil?
              user_available = current_user
              assignation << assignation_id
            elsif user_available == current_user
              assignation << assignation_id
            else
              user_available = -1
              assignation.clear
            end
          end
      end

      if user_available && user_available != -1
        assignation_update = Assignation.where(id: assignation)

        if assignation_update
          Assignation.where(id: assignation).update_all(user_id: user_available)
        end
        if hours_assigned_per_user[user_available]
          hours_assigned_per_user[user_available] += assignation.size
        else
          hours_assigned_per_user[user_available] = assignation.size
        end
        exclude_dates << date
        hours_per_user[user_available] -= assignation.size
      end
    end

    { hours_assigned_per_user: hours_assigned_per_user, hours_per_user: hours_per_user, exclude_dates: exclude_dates }
  end

  def assign_collision_days(filter_availability, user_info, total_hours_per_week)
    while !filter_availability.empty?
      num +=1
      assignation = []
      
      filter_availability.each do |date, days|
        eligible_users = user_info.select { |user| user[:hours_selected] > 0 && user[:restriction_date] != date}
        user_with_min_hours_assigned = eligible_users.sort_by { |user| [user[:hours_assigned], user[:hours_selected]] }.first
          
        user_id = user_with_min_hours_assigned[:user_id]
        days_to_delete = []
  
        if days.values.all?(false)
          filter_availability.delete(date)
          next 
        end
  
        days.each do |assignation_id, hours|
          has_hours = verify_if_user_has_hours_to_assign(days, user_id)
          unless has_hours
            user_info.each do |user|
              if user[:user_id] == user_id
                user[:restriction_date] = date
                break
              end
            end
            break
          end
          
          if hours[user_id.to_s]
            days_to_delete << assignation_id
            assignation << assignation_id
          end
        end
  
        days_to_delete.each { |assignation_id| days.delete(assignation_id) }
  
        if days.empty?
          filter_availability.delete(date)
        end
  
        if assignation.any?
          assignation_update = Assignation.where(id: assignation)
          if assignation_update && user_id
            assignation_update.update_all(user_id: user_id)
          end
          
          if assignation_update && user_id
            assignation_update.update_all(user_id: user_id)
          end
          user_info.each do |user|
            if user[:user_id] == user_id
              user[:hours_assigned] += assignation.size
              user[:hours_selected] -= assignation.size
              break
            end
          end
          
          assignation.clear
        end
      end
  
      break if num > 10000
      user_count = user_info.size
    end
  rescue StandardError => e
    puts "error: #{e.message}"
  end
  
  
  private
  
  def verify_if_user_has_hours_to_assign(days, user_id)
    days.any? { |day, users| users[user_id.to_s] }
  end
  
end