class ChangeConsultantIdToNullableInProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_null :projects, :consultant_id, true
  end
end
