class AddAppointmentIdToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_reference :documents, :appointment, foreign_key: true
  end
end
