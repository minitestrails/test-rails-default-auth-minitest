class Recipe < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :servings, numericality: { greater_than: 0 }, allow_nil: true
  validates :prep_time, numericality: { greater_than: 0 }, allow_nil: true
end
