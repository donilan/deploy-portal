class CreateEnvs < ActiveRecord::Migration[5.0]
  def change
    create_table :envs do |t|
      t.integer :env_group_id, index: true
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
