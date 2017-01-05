class AddUpdateUrlToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :update_url, :string
  end
end
