class AddColumnSkills < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :skills, :text
  end
end
