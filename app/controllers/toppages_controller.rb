class ToppagesController < ApplicationController
  def index
    @image = Image.all.order("id DESC")
  end
end
