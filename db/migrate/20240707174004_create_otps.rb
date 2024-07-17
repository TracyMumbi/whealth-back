class CreateOtps < ActiveRecord::Migration[7.1]
  def change
    create_table :otps do |t|
      t.string :otp_no
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
