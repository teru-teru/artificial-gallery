class ToppagesController < ApplicationController
  def index
    @image = Image.all.order("id DESC")
  end
  
  def privacy_policy
  end
  
  def terms
  end
end
