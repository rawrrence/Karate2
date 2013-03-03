class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :section_id
      t.integer :student_id
      t.date :date
      t.boolean :fee_paid
      t.integer :final_standing

      t.timestamps
    end
  end
end
