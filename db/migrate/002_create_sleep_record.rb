class CreateSleepRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in_time, null: false
      t.datetime :clock_out_time, null: false

      t.timestamps
    end
  
    add_index :sleep_records, [:user_id, :clock_in_time]
  end
end
