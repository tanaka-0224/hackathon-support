class User < ApplicationRecord
  has_secure_password
  has_many :project_members
  has_many :projects, through: :project_members

  validates :name, { presence: true }
  validates :email, { presence: true, uniqueness: true }
  validates :password, { presence: true }
end
