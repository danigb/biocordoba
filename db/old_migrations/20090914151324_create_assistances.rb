class CreateAssistances < ActiveRecord::Migration
  def self.up
    create_table :assistances do |t|
      t.date :day
      t.time :arrive, :leave
      t.integer :preference_id
      t.timestamps
    end
    remove_column :preferences, :day_22_arrival, :day_23_arrival, :day_24_arrival, :day_22_leave, :day_23_leave, :day_24_leave
    Preference.all.each do |p|
      %w(22 23 24).each do |day|
        Assistance.create(:day => Date.parse("#{day}-09-2009"), :preference_id => p.id, :arrive => Time.parse("10:00"), :leave => Time.parse("19:00"))
      end
    end
  end

  def self.down
    drop_table :assistances
    change_table :preferences do |f|
      f.time :day_22_arrival, :day_23_arrival, :day_24_arrival, :day_22_leave, :day_23_leave, :day_24_leave
    end
  end
end
