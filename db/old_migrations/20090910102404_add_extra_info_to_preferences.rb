class AddExtraInfoToPreferences < ActiveRecord::Migration
  def self.up
    change_table :preferences do |f|
      f.time :day_22_arrival, :day_23_arrival, :day_24_arrival
      f.time :day_22_leave, :day_23_leave, :day_24_leave
    end
  end

  def self.down
    remove_column :preferences, :day_22_arrival, :day_23_arrival, :day_24_arrival, :day_22_leave, :day_23_leave, :day_24_leave
  end
end
