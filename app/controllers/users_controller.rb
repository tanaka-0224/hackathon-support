class UsersController < ApplicationController
  def index
  end

  def new
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.new(name: params[:name], email: params[:email])
    @user.save
    if @user.save
      redirect_to("/")
    else
      redirect_to("/signup")
    end
  end
end
