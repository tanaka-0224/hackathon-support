class Project < ApplicationRecord
  has_many :project_members
  has_many :users, through: :project_members
  has_many :tasks
end
