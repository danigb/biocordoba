class AlterProfileFromLocalityToTown < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :locality_id
    add_column :profiles, :town_id, :integer
  end

  def self.down
    remove_column :profiles, :town_id
    add_column :profiles, :locality_id, :integer
  end
end
