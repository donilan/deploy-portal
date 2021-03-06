class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, index: true
      t.string :name
      t.string :author
      t.boolean :notify, defaul: false
      t.string :version, default: '1.0'
      t.boolean :admin_only, default: true
      t.integer :env_group_id, index: true
      t.text :desc
      t.text :script

      t.timestamps
    end
  end
end
