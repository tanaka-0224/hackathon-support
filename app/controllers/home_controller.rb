class HomeController < ApplicationController
  def top
    @members = User.all
  end

  def search
    # IDで検索する場合、他の条件に変更可能
    if params[:id].present?
      @members = User.where(id: params[:id])  # モデル名は適宜変更
    else
      @members = []
    end

    render json: @members
  end
end
