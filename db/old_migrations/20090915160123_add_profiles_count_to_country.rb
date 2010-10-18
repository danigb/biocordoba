class AddProfilesCountToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :profiles_count, :integer, :default => 0
    Country.all.each do |c|
      num = Profile.count(:all, :conditions => {:country_id => c.id})
      Country.update_counters(c.id, :profiles_count => num) if num > 0
    end
  end

  def self.down
    remove_column :countries, :profiles_count
  end
end
