class AddProvincesData < ActiveRecord::Migration
  def self.up
    require "fastercsv"
    FasterCSV.read("#{RAILS_ROOT}/lib/db/provinces.csv").each do |row|
      idx, name = row
      Province.create(:id => idx, :name => name)
    end
  end

  def self.dow
    Province.destroy_all
  end
end
