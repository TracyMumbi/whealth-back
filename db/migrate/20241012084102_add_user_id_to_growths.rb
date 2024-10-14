class AddUserIdToGrowths < ActiveRecord::Migration[7.1]
  def change
    add_reference :growths, :user, foreign_key: true
  end
end
