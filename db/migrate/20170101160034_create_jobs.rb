class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.integer :task_id
      t.string :status
      t.datetime :finished_at
      t.datetime :started_at
      t.integer :user_id

      t.timestamps
    end
  end
end
