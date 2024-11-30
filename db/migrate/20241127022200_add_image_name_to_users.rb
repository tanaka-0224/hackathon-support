class AddImageNameToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :image_name, :string
  end
end
