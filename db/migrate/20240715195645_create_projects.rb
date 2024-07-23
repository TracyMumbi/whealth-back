class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :status
      t.references :consultant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
