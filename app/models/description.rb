class Description < ApplicationRecord
  belongs_to :image
  belongs_to :tag

  def self.ranking
    self.group(:tag_id).order("count_tag_id DESC").limit(10).count(:tag_id)
  end

  def self.ranking_for_search
    self.group(:tag_id).order("count_tag_id DESC").count(:tag_id)
  end

end
