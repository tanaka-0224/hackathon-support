class UsersController < ApplicationController
  # before_action :authenticate_user, { only: [ :index, :show, :edit, :update ] }
  def index
  end

  def new
    @user = User.new
  end

  def show
    Rails.logger.debug "params[:id]: #{params[:id]}"
    @user = User.find_by(id: params[:id])
    Rails.logger.debug "@user: #{@user.inspect}"
    if @user
      @projects = @user.projects
    end
  end

  def create
    @user = User.new(create_user_params)

    if @user.save
      if params[:user][:image_name]
        # ファイルを保存
        image = params[:user][:image_name] # ActionDispatch::Http::UploadedFile オブジェクト
        file_name = "#{@user.id}.jpg" # 保存するファイル名
        File.binwrite("public/user_images/#{file_name}", image.read)

        # 正しいファイル名をデータベースに保存
        @user.update(image_name: file_name)
      end

      session[:user_id] = @user.id
      flash[:notice] = "Signup success!!"
      redirect_to("/show/#{session[:user_id]}")
    else
      @error_message = "Failed"
      @name = params[:user][:name]
      @password = params[:user][:password]
      render :new
    end
  end


  def create_user_params
    params.require(:user).permit(:name, :email, :password, :image_name, :skills)
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

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def update
    @user = User.find_by(id: params[:id])
    @projects = @current_user.projects
    if @current_user.update(skills_user_params)
      respond_to do |format|
        format.html { redirect_to user_path(@current_user), notice: "スキルが更新されました。" }
        format.json { render json: { message: "スキルが更新されました。", skills: @current_user.skills }, status: :ok }
      end
    else
      Rails.logger.info @current_user.errors.full_messages # エラー内容をログに出力

      respond_to do |format|
        format.html { render :show, alert: "スキルの更新に失敗しました。" }
        format.json { render json: { message: "スキルの更新に失敗しました。", errors: @current_user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  def skills_user_params
    params.require(:user).permit(:skills)
  end
end
