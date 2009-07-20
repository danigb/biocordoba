class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :meetings_number, :meetings_duration
      t.date :event_start_day, :event_end_day
      t.time :event_day_start_at, :event_day_end_at
      t.timestamps
    end

    add_column :users, :preference_id, :integer
  end
  
  def self.down
    drop_table :preferences
    remove_column :users, :preference_id
  end
end
