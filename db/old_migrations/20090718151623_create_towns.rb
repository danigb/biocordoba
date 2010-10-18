class CreateTowns < ActiveRecord::Migration
  def self.up
    create_table :towns, :id => false do |t|
      t.integer :idx
      t.string :name
      t.integer :province_id      
    end
    
    require "fastercsv"
    FasterCSV.read("#{RAILS_ROOT}/lib/db/towns.csv").each do |row|
      idx, name, province_id = row
      Town.create(:idx => idx, :name => name, :province_id => province_id).save
    end
    
    rename_column :towns, :idx, :id
  end

  def self.down
    remove_table :towns
  end
end
