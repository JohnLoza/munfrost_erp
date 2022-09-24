class InventoryFile < ApplicationRecord
  has_one_attached(:file)

  validates(:file, presence: true)

  scope :recent, -> { order(created_at: :desc) }
end

