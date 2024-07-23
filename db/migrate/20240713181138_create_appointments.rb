class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :title
      t.text :body
      t.string :date
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
