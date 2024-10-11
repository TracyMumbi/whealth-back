class Project < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :consultant, optional: true
  has_many :appointments#, dependent: :destroy  
end
