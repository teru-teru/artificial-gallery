require "net/http"
require "json"
class ImagesController < ApplicationController
  
  def show
     @image = Image.find_by(id: params[:id])
     if @image.nil?
      flash[:warning]= "画像ページがありません"
      redirect_to root_url 
    end
  end

  def new
    @image = Image.new
  end
  
  def confidence
    ranking_image_id = Caption.ranking_for_confidence.pluck(:image_id)
    @image_ranking = Image.find(ranking_image_id)
  end

  def create
    if params[:image].nil?
      flash[:danger] = "画像を選択してください"
      redirect_to new_image_url and return
    end

    @image = Image.new(image_params)

    if @image.save
      flash[:success] = "画像を投稿しました"
      
      # リクエスト用画像URL
      @image_url = @image.image.url
      # リクエストの生成
      uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze')
      uri.query = URI.encode_www_form({
        'visualFeatures' => 'Description', #取得データを選択
        'language' => "ja", #言語を選択,
      })

      http = Net::HTTP::Post.new(uri.request_uri)
      http['Content-Type'] = 'application/json'
      http['Ocp-Apim-Subscription-Key'] = '5712dc41a39645cbad4bef6df0b69585' #テスト用key→本番用は外だしで管理
      http.body = { url: @image_url }.to_json 

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
        @caption.text = "??????????"
        @caption.confidence = 0
      end
      @caption.save
      #テスト用
      @@json = @json
      redirect_to @image
    else
      flash.now[:danger] = "画像の投稿に失敗しました"
      render :new
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:success] = "画像を削除しました。"
    redirect_to root_url
  end
  
  private
  
  def image_params
    params.require(:image).permit(:image)
  end
  
end
