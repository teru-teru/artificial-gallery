class Image < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  
  has_many :descriptions, dependent: :destroy
  has_many :tags, through: :descriptions
  has_one :caption, dependent: :destroy, class_name: Caption
  
  validates :image, presence: true
  validates :language, presence: true
  
  def describe(tag)
    self.descriptions.find_or_create_by(tag_id: tag.id)
  end
  
  def describe?(tag)
    self.descripntions.include?(tag)
  end
  
  #同じタグを多く持つ画像順に{image_id =>タグ数 }ハッシュを取得
  def same_tag_images
    same_tag = {}

    self.tags.each do |t|
      t.images.each do |i|
        unless i.id == self.id
          if same_tag.key?(i.id)
            same_tag[i.id] = same_tag[i.id] += 1
          else
            same_tag[i.id] = 1
          end
        end
      end
    end
    
    same_tag.sort_by{ | k, v | v}.reverse.to_h
  end
  
end
  