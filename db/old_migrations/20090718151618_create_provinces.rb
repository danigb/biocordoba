class CreateProvinces < ActiveRecord::Migration
 def self.up
    create_table :provinces, :id => false do |t|
      t.integer :idx
      t.string :name
    end
    
    require "fastercsv"
    FasterCSV.read("#{RAILS_ROOT}/lib/db/provinces.csv").each do |row|
      idx, name, autonomy_id = row
      Province.create(:idx => idx, :name => name)
    end
    rename_column :provinces, :idx, :id
  end

  def self.down
    remove_table :provinces
  end
end
