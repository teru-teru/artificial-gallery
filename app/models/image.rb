class Image < ApplicationRecord
  mount_uploader :image, ImageUploader
  
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
  
  
  # ↓request が　undifinedとなりうまくいかない
  # def dcomputer_vision(_API)
  #     # リクエスト用画像URL
  #     @image_url = request.url.gsub("#{request.fullpath}", "") + self.image.url
  #     # リクエストの生成
  #     uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze')
  #     uri.query = URI.encode_www_form({
  #       'visualFeatures' => 'Description',
  #       'language' => 'ja'
  #     })

  #     http = Net::HTTP::Post.new(uri.request_uri)
  #     http['Content-Type'] = 'application/json'
  #     http['Ocp-Apim-Subscription-Key'] = '5712dc41a39645cbad4bef6df0b69585' #テスト用key→本番用は外だしで管理
      
  #     http.body = { url: "http://cp.glico.jp/powerpro/wp-content/uploads/entry93-630x430.jpg"  }.to_json #解析する画像URL @image_url→cloud9だとエラー
      
  #     #"http://cp.glico.jp/powerpro/wp-content/uploads/entry93-630x430.jpg" 　←水泳画像URL：説明、タグともにありの例
  #     #"https://d1kls9wq53whe1.cloudfront.net/articles/18628/200x300/16c863cfeba7608d4f676bf78edba9ce.jpg" ←モアイ画像URL：説明なしの例
      
  #     response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |client|
  #       client.request(http)
  #     end

  #     # レスポンスの加工
  #     @json = JSON.parse(response.body)
  # end
  
end
  