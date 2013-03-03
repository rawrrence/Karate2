class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :rank
      t.string :phone
      t.boolean :waiver_signed
      t.boolean :active

      t.timestamps
    end
  end
end
