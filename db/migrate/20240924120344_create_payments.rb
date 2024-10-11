class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :amount
      t.references :user, null: false, foreign_key: true
      t.datetime :paid_at

      t.timestamps
    end
  end
end
