class AddAmountToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :amount, :integer
  end
end
