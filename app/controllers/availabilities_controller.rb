class AvailabilitiesController < ApplicationController
  def index
    start_week = params[:start_week]
    end_week = params[:end_week]

    if !params[:start_week] || !params[:end_week] || params[:start_week] === nil || params[:end_week] === nil
      render json: { message: "Falta fecha de inicio y termino" }, status: :unprocessable_entity
      return
    end

    availabilities = Availability.includes([:user, :assignation]).where(assignation: { date: start_week..end_week })

    group_by_dates = availabilities.group_by { |availability| availability.assignation.date }
                                   .transform_values do |records|
      records.map do |record|
        {
          availability_id: record.id,
          assignation_id: record.assignation_id,
          user_id: record.user_id,
          end_time: record.assignation&.end_time,
          start_time: record.assignation&.start_time,
          user_name: record.user&.name,
          enabled: record.enabled,
          date: record.assignation&.date
        }
      end
    end
    
    render json: {
      availabilities_group_by_dates: group_by_dates.as_json,
      availabilities: availabilities.as_json(include: { assignation: { only: [:id, :date] } })
    }

  end

  def update_multiple
    data = params[:data]
    availability = params[:test].permit!.to_h
    start_week = params[:start_week]
    end_week = params[:end_week]
    hours_per_user = params.require(:hours_per_user).permit!.to_h

    # Elimina fechas cuando todas las horas son falsas
   
    availability_filter = availability.each_with_object({}) do |(date, hours_by_user), result|
      # Filtra las asignaciones que no tienen todas las horas en false
      filtered_assignations = hours_by_user.select do |assignation_id, hours|
        !hours.values.all?(false)
      end
    
      # Si hay asignaciones restantes, agrega la fecha y sus asignaciones filtradas al resultado
      unless filtered_assignations.empty?
        result[date] = filtered_assignations
      end
    end

    #limpiar asignaciones
    assignation = Assignation.where(date: start_week..end_week)
    clean_assignation = assignation.update!(user_id: nil)
    total_hours_per_week = assignation.count

    data.each do |d|
      findAvailability = Availability.find_by(id: d[:id])
      if findAvailability
        findAvailability.update(enabled: d[:enabled])
      else
        render json: {
          ok: false
        }, status: :not_found
      end
    end

    greedy_service = GreedyService.new
    assign_exclusive_day = greedy_service.assign_exclusive_day(availability.to_h, hours_per_user.to_h)
    exclude_dates = assign_exclusive_day[:exclude_dates]
    hours_assigned_per_user = assign_exclusive_day[:hours_assigned_per_user]
    updated_hours_availables_per_user = assign_exclusive_day[:hours_per_user]

    user_info = []

    # Itera sobre las claves de ambos hashes combinados
    (all_keys = (hours_assigned_per_user.keys + updated_hours_availables_per_user.keys).uniq).each do |key|
      # Obtén los valores de horas asignadas y horas seleccionadas
      hours_assigned = hours_assigned_per_user[key] || 0
      hours_selected = updated_hours_availables_per_user[key] || 0

      # Agrega el hash con la estructura deseada al arreglo
      user_info << {user_id: key.to_i, hours_assigned: hours_assigned, hours_selected: hours_selected}
    end

    filter_availability = availability_filter.reject { |date| exclude_dates.include?(date)}
    assign_collision_days = greedy_service.assign_collision_days(filter_availability, user_info, total_hours_per_week)


    render json: {
      ok: true,
      # result: result.as_json,
      # a: a.as_json
    }
  end
  
  private

  def availabilities_params
    params.require(:availability).permit(:enabled)
  end
end
