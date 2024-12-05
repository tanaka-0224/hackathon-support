class ChangeDescriptionToTextInProjects < ActiveRecord::Migration[7.2]
  def change
    change_column :projects, :description, :text
  end
end
