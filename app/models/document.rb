class Document < ApplicationRecord
    has_one_attached :file_data
    # belongs_to :appointment
    has_rich_text :content
end
