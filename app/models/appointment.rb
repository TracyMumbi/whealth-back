class Appointment < ApplicationRecord
    belongs_to :project
    # has_many :documents
end
