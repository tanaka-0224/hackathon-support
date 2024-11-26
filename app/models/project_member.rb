class ProjectMember < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user, uniqueness: { scope: :project, message: "ユーザーは既にこのプロジェクトに参加しています" }
end
