class AddBodyToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :body, :string
  end
end
