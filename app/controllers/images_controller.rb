require "net/http"
require "json"

class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    
    if @image.save
      
      # リクエスト用画像URL
      @image_url = request.url.gsub("#{request.fullpath}", "") + @image.image.url
      # リクエストの生成
      uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze')
      uri.query = URI.encode_www_form({
        'visualFeatures' => 'Description',
        'language' => 'ja'
      })

      http = Net::HTTP::Post.new(uri.request_uri)
      http['Content-Type'] = 'application/json'
      http['Ocp-Apim-Subscription-Key'] = '5712dc41a39645cbad4bef6df0b69585' #テスト用key→本番用は外だしで管理
      http.body = { url: @image_url }.to_json 

      #解析する画像URL @image_url→cloud9だとエラー,herokuでOK確認済み
      #"http://cp.glico.jp/powerpro/wp-content/uploads/entry93-630x430.jpg" #←水泳画像URL：説明タグともにありの例
      #"https://d1kls9wq53whe1.cloudfront.net/articles/18628/200x300/16c863cfeba7608d4f676bf78edba9ce.jpg" #←モアイ画像URL：説明なしの例
      
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |client|
        client.request(http)
      end

      # レスポンスの加工
      @json = JSON.parse(response.body)
      
      #タグの保存、紐づけ
      tags = @json["description"]["tags"]
      tags.each do |tag|
        @tag = Tag.find_or_create_by(word: tag )
        @image.describe(@tag)
      end
      
      #キャプションの保存、紐づけ(confidence=*100小数点切り捨てで%へ)
      @caption = Caption.new
      @caption.image_id = @image.id
      if @json["description"]["captions"][0] != nil
        @caption.text = @json["description"]["captions"][0]["text"]
        @caption.confidence = @json["description"]["captions"][0]["confidence"]*100.round
      else 
        @caption.text = "??(o_o)??"
        @caption.confidence = 0
      end
      @caption.save
      
      redirect_to @image
    else
      render :new
    end
  end

  def destroy
  end
  
  private
  
  def image_params
    params.require(:image).permit(:image)
  end
  
  
end
