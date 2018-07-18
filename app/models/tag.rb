class Tag < ApplicationRecord
  has_many :descriptions
  has_many :images, through: :descriptions
end
