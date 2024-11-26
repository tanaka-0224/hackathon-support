class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "signup success!!"

      redirect_to("/show/#{session[:user_id]}")
    else
      @error_message = "Failed"
      @name = params[:user][:name]       # フォームから入力された名前
      @email = params[:user][:email]     # フォームから入力されたメールアドレス
      @password = params[:user][:password] # フォームから入力されたパスワード
      render :new # `new`アクションのビューを再表示
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Login success!"
      redirect_to("/show/#{session[:user_id]}")
    else
      @error_message = "Email or password is incorrect."
      @email = params[:email]
      render("users/login_form")
    end
  end
end
