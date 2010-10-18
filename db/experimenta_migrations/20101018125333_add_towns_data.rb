class AddTownsData < ActiveRecord::Migration
  def self.up
    require "fastercsv"
    FasterCSV.read("#{RAILS_ROOT}/lib/db/towns.csv").each do |row|
      idx, name, province_id = row
      Town.create(:id => idx, :name => name, :province_id => province_id).save
    end
  end

  def self.down
  end
end
