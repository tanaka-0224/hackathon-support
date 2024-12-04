class HomeController < ApplicationController
  def search
    # IDで検索する場合、他の条件に変更可能
    if params[:id].present?
      @members = User.where(id: params[:id])  # モデル名は適宜変更
    else
      @members = []
    end

    render json: @members
  end
  def add_member
    user = User.find(params[:user_id])
    if current_user.team_members << user
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def top
    if User.exists?(id: session[:user_id])
      @user = User.find(session[:user_id])  # ユーザーを取得
    end
    if Project.exists?(id: session[:project_id])
    @project = Project.find(session[:project_id])
    @members = ProjectMember.where(project_id: session[:project_id])
    @members.each do |member|
      puts member.user.name # userが関連付けられているか確認
    end
    end
  end
end
