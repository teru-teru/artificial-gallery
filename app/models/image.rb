class Image < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  
  has_many :descriptions, dependent: :destroy
  has_many :tags, through: :descriptions
  has_one :caption, dependent: :destroy, class_name: Caption
  
  validates :image, presence: true
  
  def describe(tag)
    self.descriptions.find_or_create_by(tag_id: tag.id)
  end
  
  def describe?(tag)
    self.descripntions.include?(tag)
  end
  
end
  