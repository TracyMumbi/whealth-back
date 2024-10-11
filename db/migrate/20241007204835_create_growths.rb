class CreateGrowths < ActiveRecord::Migration[7.1]
  def change
    create_table :growths do |t|
      t.decimal :weight
      t.decimal :height
      t.integer :age
      t.decimal :length
      t.integer :head_circumference

      t.timestamps
    end
  end
end
