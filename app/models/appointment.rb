class Appointment < ApplicationRecord
    belongs_to :project
    # paginates_per 10
    # has_many :documents
end
