class CreateQuills < ActiveRecord::Migration[7.1]
  def change
    create_table :quills do |t|
      t.text :content
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end