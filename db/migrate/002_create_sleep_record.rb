class CreateSleepRecord < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in_time
      t.datetime :clock_out_time

      t.timestamps
    end
  
    add_index :sleep_records, [:user_id, :clock_in_time]
  end
end
