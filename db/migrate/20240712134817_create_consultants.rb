class CreateConsultants < ActiveRecord::Migration[7.1]
  def change
    create_table :consultants do |t|
      t.string :name
      t.string :phone
      t.string :gender
      t.string :date_of_birth
      t.string :email
      t.string :password
      t.string :speciality
      t.string :board_number
      t.integer :experience
      t.boolean :is_client
      t.boolean :is_consultant

      t.timestamps
    end
  end
end
