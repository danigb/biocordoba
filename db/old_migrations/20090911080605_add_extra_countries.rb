class AddExtraCountries < ActiveRecord::Migration
  def self.up
    [["Mexico", "MX"],["Panamá", "PA"],["Chile", "CL"], ["Emiratos Árabes Unidos","AE"]].each do |e|
      Country.create(:name => e[0], :code => e[1])
    end
  end

  def self.down
    %w(MX PA CL AE).each do |e|
      Country.find_by_code(e).destroy
    end
  end
end
