class ChangeProjectIdToUserIdInTransactions < ActiveRecord::Migration[7.1]
  def change
       remove_foreign_key :transactions, :projects
       remove_reference :transactions, :project, index: true
   
       add_reference :transactions, :user, foreign_key: true, index: true
  end
end
