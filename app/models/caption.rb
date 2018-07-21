class Caption < ApplicationRecord
  belongs_to :image

  def self.ranking_for_confidence
    self.order("confidence DESC")
  end

end
