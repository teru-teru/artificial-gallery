class Image < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  
  has_many :descriptions, class_name: "Description", dependent: :destroy
  has_many :tags, -> { order("descriptions.id") }, through: :descriptions
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
  
  #twitter投稿用に画像についたタグ最初5つを取り出して,で接続
  def hash_tags
    @hash_tags = " "
    unless self.tags.first.nil?
      self.tags.first(5).each do |t|
        @hash_tags = @hash_tags + t.word + ","       
      end  
    end  
      return @hash_tags
  end
  
end
  