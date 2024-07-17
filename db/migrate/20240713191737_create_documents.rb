class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.binary :file_data

      t.timestamps
    end
  end
end
