class ChangePasswordToPasswordDigestInConsultants < ActiveRecord::Migration[7.1]
  def change
    rename_column :consultants, :password, :password_digest
  end
end
