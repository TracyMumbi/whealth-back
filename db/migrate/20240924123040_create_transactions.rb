class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_code
      t.references :project, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
