class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      unless @auth = Authorization.find_from_auth(auth)
        @auth = Authorization.create_from_auth(auth)
        flash[:success] = "ユーザ登録しました"
      else 
        flash[:success] = "ログインしました"
      end
      @user = @auth.user
      session[:user_id] = @user.id
      #redirect_to request.env['omniauth.origin']
      redirect_to new_image_url
    else

      email = params[:session][:email].downcase
      password = params[:session][:password]
      if login(email, password)
        flash[:success] = "ログインに成功しました。"
        redirect_to root_url
      else
        flash.now[:danger] = "ログインに失敗しました"
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to root_url
  end
  
  private
  
  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
