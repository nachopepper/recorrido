# app/services/horario_service.rb

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
        Assignation.where(id: assignation).update_all(user_id: user_available)
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
      assignation = []
      
      filter_availability.each do |date, days|
        eligible_users = user_info.select { |user| user[:hours_selected] > 0 }
        user_with_min_hours_assigned = eligible_users.min_by { |user| user[:hours_assigned] }
        user_id = user_with_min_hours_assigned[:user_id]
        days_to_delete = []
  
        if filter_availability[date.to_s].values.all?(false)
          puts "borrar"
        end

        days.each do |assignation_id, hours|
          if hours[user_id.to_s]
            days_to_delete << assignation_id
            assignation << assignation_id
          end
        end
  
        days_to_delete.each do |assignation_id|
          days.delete(assignation_id)
        end
  
        if days.empty?
          filter_availability.delete(date)
        end
  
        if assignation.any?
          Assignation.where(id: assignation).update_all(user_id: user_id)
  
          user_info.each do |user|
            if user[:user_id] == user_id
              user[:hours_assigned] += assignation.size
              user[:hours_selected] -= assignation.size
              break
            end
          end
  
          assignation.clear
        end
        puts"user_info #{user_info}"
      end
    end
  end
  
  
  
end
