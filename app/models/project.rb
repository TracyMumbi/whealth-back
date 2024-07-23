class Project < ApplicationRecord
  belongs_to :user
  belongs_to :consultant
  has_many :appointments#, dependent: :destroy
end
