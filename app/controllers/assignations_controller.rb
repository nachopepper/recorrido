class AssignationsController < ApplicationController
  def index
    start_week = params[:start_week]
    end_week = params[:end_week]
  
    if start_week.blank? || end_week.blank?
      render json: { message: "Falta fecha de inicio y termino" }, status: :unprocessable_entity
      return
    end

    assignations = Assignation.where(date: start_week..end_week).includes(:user)
  
    total_hours = assignations.count
    hours_assigned = assignations.where.not(user_id: nil).count
    hours_per_user = assignations.where.not(user_id: nil).group(:user_id).count
  
    users = User.select(:id, :name)

    hours_per_user_details = users.map do |user|
      {
        id: user.id,
        name: user.name,
        hours_assigned: hours_per_user[user.id] || 0
      }
    end
  
    group_by_dates = assignations.group_by(&:date).transform_values do |records|
      records.map do |record|
        {
          id: record.id,
          start_time: record.start_time,
          end_time: record.end_time,
          user_id: record.user_id,
          user_name: record.user&.name
        }
      end
    end
  
    render json: {
      hours_per_user: hours_per_user_details,
      assignations: group_by_dates,
      hours_ids: assignations.pluck(:id),
      users: users.as_json(only: [:id, :name]),
      total_hours: total_hours,
      hours_assigned: hours_assigned,
      hours_available: total_hours - hours_assigned,
      start_week: start_week,
      end_week: end_week
    }, status: :ok
  rescue StandardError => e
    render json: { error: "Internal server error AssignationsController#index", details: e.message }, status: :internal_server_error
  end

  def update
    assignation = Assignation.find_by(id: params[:id])
    if assignation
      assignation.update(assignation_params)
      render json: assignation, status: :ok
    else
      render json: { error: "Asignación no encontrada" }, status: :not_found
    end
    rescue StandardError => e
      render json: { error: "Internal server error AssignationsController#update", details: e.message }, status: :internal_server_error
  end

  private

  def assignation_params
    params.require(:assignation).permit(:user_id)
  end
  
end
