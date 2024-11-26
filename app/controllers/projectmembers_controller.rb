class ProjectmembersController < ApplicationController
  def index
  end

  def add_member
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])

    project_member = project.project_members.create(user: user, role: "member")
    if project_member.persisted?
      render json: { success: true, message: "メンバーを追加しました", user: { id: user.id, name: user.name } }, status: :ok
    else
      render json: { success: false, message: "メンバーの追加に失敗しました" }, status: :unprocessable_entity
    end
  end
end
