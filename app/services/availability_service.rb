class AvailabilityService
  def delete_empty_availability(availability)
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
    availability_filter
  end

  def reset_multiple_aviabilities(availability)
    availability.each do |d|
      findAvailability = Availability.find_by(id: d[:id])
      if findAvailability
        findAvailability.update(enabled: d[:enabled])
      else
        return {
          ok: false
        }
      end
    end
    { ok: true}
  end
end
