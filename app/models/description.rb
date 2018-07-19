class Description < ApplicationRecord
  belongs_to :image
  belongs_to :tag

  def self.ranking
    self.group(:tag_id).order("count_tag_id DESC").limit(15).count(:tag_id)
  end

end
