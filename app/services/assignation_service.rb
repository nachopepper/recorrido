class AssignationService
  def initialize(start_week, end_week)
    @start_week = start_week
    @end_week = end_week
  end

  def reset_user_assignments_for_week
    Assignation.where(date: @start_week..@end_week).update_all(user_id: nil)
  end
end