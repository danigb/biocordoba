class HabtmSectors < ActiveRecord::Migration
  def self.up
    create_table :profiles_sectors, :id => false do |t|
      t.integer :profile_id, :sector_id
    end
    remove_column :profiles, :sector_id
    remove_column :sectors, :profiles_count
  end

  def self.down
    drop_table :profiles_sectors
    add_column :profiles, :sector_id, :integer
    add_column :sectors, :profiles_count
  end
end
