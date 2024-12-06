class ChangeNameToTextInProjects < ActiveRecord::Migration[7.2]
  def change
    change_column :projects, :name, :text
  end
end
