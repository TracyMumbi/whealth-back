class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
