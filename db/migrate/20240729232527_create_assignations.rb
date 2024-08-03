class CreateAssignations < ActiveRecord::Migration[7.1]
  def change
    create_table :assignations do |t|
      t.date :date
      t.string :start_time
      t.string :end_time
      t.references :user, null: true, foreign_key: true
    end
  end
end
