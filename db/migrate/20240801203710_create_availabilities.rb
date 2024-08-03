class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :user, null: true, foreign_key: true
      t.references :assignation, null: true, foreign_key: true
      t.boolean :enabled, null: false, default: false
    end
  end
end
