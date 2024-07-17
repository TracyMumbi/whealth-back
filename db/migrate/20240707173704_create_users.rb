class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password
      t.string :gender
      t.string :date_of_birth
      t.string :username
      t.boolean :is_client
      t.boolean :is_consultant

      t.timestamps
    end
  end
end
