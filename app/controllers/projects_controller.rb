class ProjectsController < ApplicationController
  before_action :set_current_user
  def create
    # 新しいプロジェクトを作成
    @project = Project.new(name: "New Project") # 必要に応じて属性を追加

    if @project.save
      @project.project_members.create(user_id: @current_user.id, role: "owner")
      session[:project_id] = @project.id  # プロジェクトIDをセッションに保存
      flash[:notice] = "プロジェクトが作成されました。"
      redirect_to("/")
    else
      flash[:alert] = "プロジェクトの作成に失敗しました: #{@project.errors.full_messages.join(', ')}"
      redirect_to("/signup")  # 失敗時も / にリダイレクト
    end
  end

  def search_members
    query = params[:query]
    project_id = params[:project_id]

    # ログイン済みユーザーのプロジェクトにすでに追加されていないユーザーを検索
    project = Project.find(project_id)
    members = User.where("name LIKE ?", "%#{query}%")
                  .where.not(id: project.user_ids) # すでに追加済みのユーザーは除外

    render json: members
  end

  def show
    @project = Project.find(params[:id])
    @members = @project.users # プロジェクトメンバーを取得（`has_many :users`の関係があることを前提）
  end
end
